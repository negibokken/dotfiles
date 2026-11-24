"""Exercise repository scoping without using a real GitHub credential."""

import os
import runpy
import subprocess
import unittest
from pathlib import Path
from unittest.mock import patch

CLI = runpy.run_path(str(Path(__file__).resolve().parents[1] / "gh-personal"))
scope = CLI["github_command"].__globals__


def command(args):
    return CLI["github_command"](args)[0]


class PersonalGitHubTest(unittest.TestCase):
    def test_repository_list_pins_owner(self):
        self.assertEqual(
            command(["repo", "list", "--limit", "5"]),
            ["repo", "list", "negibokken", "--limit", "5"],
        )

    def test_repository_targets(self):
        for origin in (
            "git@github.com:negibokken/dotfiles.git",
            "ssh://git@github.com/negibokken/dotfiles.git",
            "https://github.com/negibokken/dotfiles.git",
        ):
            with (
                self.subTest(origin=origin),
                patch.dict(scope, git_value=lambda *args, origin=origin: origin),
            ):
                self.assertEqual(
                    command(["repo", "view"]), ["repo", "view", "negibokken/dotfiles"]
                )
        self.assertEqual(
            command(["repo", "archive", "negibokken/dotfiles", "--yes"]),
            ["repo", "archive", "negibokken/dotfiles", "--yes"],
        )

    def test_other_owner_is_rejected_before_keychain_lookup(self):
        cases = (
            ["repo", "list", "example-org"],
            ["repo", "edit", "example-org/example-repo"],
            ["repo", "view", "https://other.example/negibokken/dotfiles"],
            ["-R", "example-org/example-repo", "pr", "list"],
            ["-R", "negibokken/dotfiles", "pr", "list", "-Rexample-org/example-repo"],
            [
                "-R",
                "negibokken/dotfiles",
                "pr",
                "list",
                "--search=repo:example-org/example-repo",
            ],
            ["pr", "view", "https://github.com/example-org/example-repo/pull/1"],
            ["api", "repos/example-org/example-repo"],
            ["api", "repos/negibokken/dotfiles/../../example-org/example-repo"],
            ["api", "repos/negibokken/dotfiles/%2e%2e"],
            ["api", "repos/negibokken/dotfiles", "--hostname", "other.example"],
            ["--run", "gh", "repo", "view", "example-org/example-repo"],
        )
        with patch.dict(scope, keychain=lambda *_: self.fail("Keychain was accessed")):
            for args in cases:
                with self.subTest(args=args), self.assertRaises(SystemExit):
                    CLI["main"](args)

    def test_foreign_origin(self):
        with (
            patch.dict(
                scope,
                git_value=lambda *args: "git@github.com:example-org/example-repo.git",
            ),
            self.assertRaises(SystemExit),
        ):
            command(["repo", "view"])

    def test_transfer_redirect_is_rejected(self):
        response = subprocess.CompletedProcess([], 0, stdout="example-org/dotfiles\n")
        with (
            patch.object(subprocess, "run", return_value=response) as request,
            self.assertRaises(SystemExit),
        ):
            CLI["verify_repository"]("negibokken/dotfiles", {})
        self.assertIn("followRenames: false", " ".join(request.call_args.args[0]))

    def test_pr_create_pins_head(self):
        with patch.dict(
            scope,
            git_value=lambda subcommand, *args: (
                "git@github.com:negibokken/dotfiles.git"
                if subcommand == "remote"
                else "feature"
            ),
        ):
            self.assertEqual(
                command(["pr", "create", "--draft"]),
                [
                    "pr",
                    "create",
                    "--repo",
                    "negibokken/dotfiles",
                    "--head=feature",
                    "--draft",
                ],
            )
            with self.assertRaises(SystemExit):
                command(["pr", "create", "-dHexample-org:feature"])

    def test_work_environment_cannot_override_target_or_token(self):
        with patch.dict(
            os.environ,
            GH_REPO="example-org/example-repo",
            GH_HOST="other.example",
            GH_TOKEN="work",
            GH_ENTERPRISE_TOKEN="work",
            GH_DEBUG="api",
        ):
            env = CLI["clean_environment"]()
        self.assertEqual(env["GH_HOST"], "github.com")
        for name in ("GH_REPO", "GH_TOKEN", "GH_ENTERPRISE_TOKEN", "GH_DEBUG"):
            self.assertNotIn(name, env)


if __name__ == "__main__":
    unittest.main()
