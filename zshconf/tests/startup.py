#!/usr/bin/env python3
"""Exercise zsh startup and helpers without user settings or a real tmux server."""

import json
import os
import pty
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SHELLS = [Path("/bin/zsh"), Path("/opt/homebrew/bin/zsh")]
SHELLS = [str(shell) for shell in SHELLS if shell.exists()]
GIT_WT = shutil.which("git-wt")


class ZshTests(unittest.TestCase):
    def setUp(self):
        self.sandbox = tempfile.TemporaryDirectory(prefix="dotfiles-zsh-")
        self.addCleanup(self.sandbox.cleanup)
        self.sandbox_home = Path(self.sandbox.name)
        self.bin_dir = self.sandbox_home / ".local/bin"
        self.bin_dir.mkdir(parents=True)
        self.log = self.sandbox_home / "calls.log"
        self.env = {
            "HOME": str(self.sandbox_home),
            "ZDOTDIR": str(self.sandbox_home),
            "PATH": "/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin",
            "TERM": "xterm-256color",
            "LANG": "en_US.UTF-8",
            "IS_CRON": "true",
            "ZSH_TEST_ROOT": str(ROOT),
            "ZSH_TEST_LOG": str(self.log),
        }
        (self.sandbox_home / ".zshrc").symlink_to(ROOT / "_zshrc")
        (self.sandbox_home / ".zshrc.local").write_text(
            'export PATH="/opt/homebrew/bin:$PATH"\nalias local_command=true\n'
        )
        self.executable("tmux", 'printf "tmux %s\\n" "$*" >> "$ZSH_TEST_LOG"\n')
        self.executable("peco", "cat >/dev/null\nexit 1\n")
        self.executable("gh", "exit 0\n")
        self.executable("gh-write", "exit 0\n")
        self.executable("pbcopy", "cat >/dev/null\n")
        shims_dir = self.sandbox_home / ".local/share/mise/shims"
        shims_dir.mkdir(parents=True)
        for name in ["node", "pnpm", "go", "python3"]:
            shim = shims_dir / name
            shim.write_text("#!/bin/sh\nexit 0\n")
            shim.chmod(0o700)
        self.executable(
            "starship",
            'printf "starship %s\\n" "$*" >> "$ZSH_TEST_LOG"\n'
            "cat <<'EOF'\n"
            "autoload -Uz add-zsh-hook\n"
            "prompt_starship_precmd() { :; }\n"
            "add-zsh-hook precmd prompt_starship_precmd\n"
            "EOF\n",
        )
        if GIT_WT:
            self.executable(
                "git-wt",
                'printf "git-wt %s\\n" "$*" >> "$ZSH_TEST_LOG"\n'
                f'exec "{GIT_WT}" "$@"\n',
            )

    def executable(self, name, body):
        target = self.bin_dir / name
        target.write_text("#!/bin/sh\n" + body)
        target.chmod(0o700)

    def run_zsh(
        self, script, *, shell=None, startup=False, login=False, tty=False, env=None
    ):
        shell = shell or SHELLS[0]
        flags = "-ilc" if login else "-ic" if startup else "-fc"
        if not startup:
            script = 'source "$ZSH_TEST_ROOT/zshconf/functions.zsh"\n' + script
        # Every assertion runs explicitly; do not let a later command hide failure.
        script = "setopt err_exit\n" + script + "\nunset HISTFILE\n"
        config_env = self.env | (env or {})
        master = slave = None
        try:
            if tty:
                master, slave = pty.openpty()
            result = subprocess.run(
                [shell, flags, script],
                check=False,
                env=config_env,
                cwd=self.sandbox_home,
                stdin=slave if tty else subprocess.DEVNULL,
                stdout=slave if tty else subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=15,
            )
        finally:
            if master is not None:
                os.close(master)
                os.close(slave)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        return result.stdout or ""

    def test_startup_matrix_and_command_precedence(self):
        for shell in SHELLS:
            for login in [False, True]:
                with self.subTest(shell=shell, login=login):
                    self.log.unlink(missing_ok=True)
                    self.run_zsh(
                        r"""
[[ $path[1] == "$HOME/.local/bin" ]]
[[ $path[2] == "$HOME/.local/share/mise/shims" ]]
[[ $#path == ${#${(u)path}} ]]
[[ ${path[(Ie)$HOME/.pyenv/shims]} == 0 ]]
[[ ${path[(Ie)/missing-old-go/bin]} == 0 ]]
[[ -z ${GOROOT-} ]]
[[ $(whence -p gh) == "$HOME/.local/bin/gh" ]]
[[ $(whence -p gh-write) == "$HOME/.local/bin/gh-write" ]]
for tool in node pnpm go python3; do
  [[ $(whence -p "$tool") == "$HOME/.local/share/mise/shims/$tool" ]]
done
(( $+functions[compdef] && $+functions[_zsh_highlight] ))
(( ! $+functions[mktemp] && ! $+aliases[rm] ))
[[ $(bindkey '^R') == *peco-select-history* ]]
[[ $(bindkey '^X^E') == *edit-command-line* ]]
[[ $(bindkey '^A') == *beginning-of-line* ]]
[[ $(bindkey '^P') == *history-beginning-search-backward-end* ]]
(( $+aliases[local_command] ))
[[ $aliases[dcku] == 'docker compose up' ]]
if (( $+commands[git-wt] )); then
  (( $+functions[git] && $+functions[_git-wt] ))
  [[ $_comps[git] == _git-wt-wrapper ]]
fi
""",
                        shell=shell,
                        startup=True,
                        login=login,
                        env={
                            "GOROOT": "/missing-old-go",
                            "PATH": self.env["PATH"]
                            + f":{self.sandbox_home}/.pyenv/shims:/missing-old-go/bin",
                        },
                    )
                    calls = self.log.read_text().splitlines()
                    self.assertEqual(calls.count("starship init zsh"), 1)
                    if GIT_WT:
                        self.assertEqual(calls.count("git-wt --init zsh"), 1)
                    self.assertFalse(any(line.startswith("tmux ") for line in calls))

    def test_completion_initializes_once_and_local_file_is_optional(self):
        (self.sandbox_home / ".zshrc.local").unlink()
        (self.sandbox_home / ".zshenv").write_text("zmodload zsh/zprof\n")
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output = self.run_zsh("zprof", shell=shell, startup=True)
                self.assertRegex(output, r"(?m)^\s*\d+\)\s+1\s+.*\scompinit$")

    def test_tmux_conditions_with_a_stub_and_pty(self):
        scenarios = [
            ({"IS_CRON": "false"}, True, True, True),
            ({"IS_CRON": "false", "TMUX": "existing"}, True, True, False),
            ({"IS_CRON": "true"}, True, True, False),
            ({"IS_CRON": "false", "TERM_PROGRAM": "vscode"}, True, True, False),
            ({"IS_CRON": "false", "TERM_PROGRAM": "Orca"}, True, True, False),
            ({"IS_CRON": "false"}, True, False, False),
            ({"IS_CRON": "false"}, False, True, False),
        ]
        for shell in SHELLS:
            for env, interactive, tty, expected in scenarios:
                with self.subTest(
                    shell=shell, env=env, interactive=interactive, tty=tty
                ):
                    self.log.unlink(missing_ok=True)
                    script = ":" if interactive else 'source "$ZSH_TEST_ROOT/_zshrc"'
                    self.run_zsh(
                        script, shell=shell, startup=interactive, tty=tty, env=env
                    )
                    calls = self.log.read_text().splitlines()
                    self.assertEqual(calls.count("tmux new-session"), int(expected))
                    if expected:
                        self.assertEqual(calls[0], "tmux new-session")

    def test_directory_helpers_and_standard_mktemp(self):
        for shell in SHELLS:
            with self.subTest(shell=shell):
                name = str(SHELLS.index(shell))
                self.run_zsh(
                    r"""
function ghq() { print -r -- "$HOME/repos with spaces"; }
function git() { print -r -- "$*" >> "$ZSH_TEST_LOG"; }
export B_PROFILE='example user'
mkdev "repository $ZSH_TEST_CASE"
[[ $PWD == "$HOME/repos with spaces/github.com/example user/repository $ZSH_TEST_CASE" ]]
[[ $(<README.md) == "# repository $ZSH_TEST_CASE" ]]
mkcd 'sub dir'
[[ ${PWD:t} == 'sub dir' ]]
mktmp "scratch $ZSH_TEST_CASE" -d 'description with spaces and \backslash'
[[ $PWD == "$HOME/temp/scratch $ZSH_TEST_CASE" ]]
[[ $(<README.md) == *'description with spaces and \backslash' ]]
mktmp "plain $ZSH_TEST_CASE"
[[ $(<README.md) == "# plain $ZSH_TEST_CASE" ]]
[[ -z ${description-} && -z ${destination-} && -z ${root_dir-} ]]
created=$(command mktemp "$HOME/standard.XXXXXX")
[[ -f $created ]]
""",
                    shell=shell,
                    env={"ZSH_TEST_CASE": name},
                )

    def test_invalid_arguments_and_existing_directories_do_not_change_cwd(self):
        self.run_zsh(
            r"""
original=$PWD
if mktmp -d 2>/dev/null; then return 1; fi
[[ $PWD == $original ]]
if mkcd 2>/dev/null; then return 1; fi
mktmp 'existing directory'
print sentinel > README.md
builtin cd -- "$original"
if mktmp 'existing directory' 2>/dev/null; then return 1; fi
[[ $(<"$HOME/temp/existing directory/README.md") == sentinel ]]
[[ $PWD == $original ]]
if mkcd "$HOME/temp/existing directory" 2>/dev/null; then return 1; fi
[[ $PWD == $original ]]
"""
        )

    def test_peco_cancellation_preserves_cwd_and_command_buffer(self):
        self.run_zsh(
            r"""
function peco() { command cat >/dev/null; return 1; }
function ghq() { print -r -- "$HOME"; }
function git() { print '[]'; }
command mkdir -p "$HOME/temp/one" "$HOME/Project/one"
original=$PWD
temp
pro
ghq-peco
wt
BUFFER='keep this command'
LBUFFER=$BUFFER
peco-select-history
[[ $BUFFER == 'keep this command' && $PWD == $original ]]
"""
        )

    def test_selectors_preserve_paths_with_spaces(self):
        self.run_zsh(
            r"""
function peco() { command cat >/dev/null; print -r -- "$ZSH_TEST_SELECTION"; }
function ghq() { print -r -- "$HOME/repo with spaces"; }
function git() {
  if [[ $1 == wt && $2 == --json ]]; then
    print -r -- "$ZSH_TEST_WORKTREES"
  elif [[ $1 == wt ]]; then
    builtin cd -- "$2"
  else
    return 1
  fi
}
command mkdir -p "$HOME/repo with spaces" "$HOME/temp/scratch with spaces"
export ZSH_TEST_SELECTION="$HOME/repo with spaces"
ghq-peco
[[ $PWD == "$HOME/repo with spaces" ]]
builtin cd -- "$HOME"
export ZSH_TEST_SELECTION=$'1\tscratch with spaces\tsummary'
temp
[[ $PWD == "$HOME/temp/scratch with spaces" ]]
export ZSH_TEST_SELECTION="$HOME/repo with spaces"$'\tmain'
wt
[[ $PWD == "$HOME/repo with spaces" ]]
""",
            env={
                "ZSH_TEST_WORKTREES": json.dumps(
                    [
                        {
                            "path": str(self.sandbox_home / "repo with spaces"),
                            "branch": "main",
                        }
                    ]
                )
            },
        )

    def test_node_scripts_use_pnpm_and_forward_arguments(self):
        (self.sandbox_home / "package.json").write_text(
            json.dumps({"scripts": {"test script": "echo example"}})
        )
        self.run_zsh(
            r"""
function peco() { command cat >/dev/null; print -r -- $'test script\techo example'; }
function pnpm() { printf '%s\n' "$@" > "$ZSH_TEST_LOG"; }
peco-node-scripts --watch
"""
        )
        self.assertEqual(
            self.log.read_text().splitlines(), ["run", "test script", "--watch"]
        )

    def test_node_script_cancellation_does_not_run_pnpm(self):
        (self.sandbox_home / "package.json").write_text('{"scripts":{"test":"true"}}')
        self.run_zsh(
            r"""
function peco() { command cat >/dev/null; return 1; }
function pnpm() { print unexpected > "$ZSH_TEST_LOG"; }
peco-node-scripts
"""
        )
        self.assertFalse(self.log.exists())

    @unittest.skipUnless(GIT_WT, "git-wt is required for the integration test")
    def test_real_git_wt_changes_directory_with_spaces(self):
        for index, shell in enumerate(SHELLS):
            with self.subTest(shell=shell):
                repository = self.sandbox_home / f"real repository {index}"
                repository.mkdir()
                repository = repository.resolve()
                subprocess.run(
                    [
                        "git",
                        "init",
                        "-q",
                        "--initial-branch=test-root",
                        str(repository),
                    ],
                    check=True,
                    capture_output=True,
                )
                subprocess.run(
                    [
                        "git",
                        "-c",
                        "core.hooksPath=/dev/null",
                        "-c",
                        "user.name=Zsh Test",
                        "-c",
                        "user.email=zsh-test@example.invalid",
                        "commit",
                        "--no-gpg-sign",
                        "--allow-empty",
                        "-qm",
                        "Test fixture",
                    ],
                    cwd=repository,
                    check=True,
                    capture_output=True,
                )
                self.run_zsh(
                    r"""
builtin cd -- "$ZSH_TEST_REPOSITORY"
git wt test-feature HEAD >/dev/null 2>"$HOME/git-wt.stderr" || {
  command cat "$HOME/git-wt.stderr" >&2
  return 1
}
[[ $PWD != "$ZSH_TEST_REPOSITORY" && -d $PWD ]]
[[ $(git branch --show-current) == test-feature ]]
git wt test-root >/dev/null 2>"$HOME/git-wt.stderr" || {
  command cat "$HOME/git-wt.stderr" >&2
  return 1
}
[[ $PWD == "$ZSH_TEST_REPOSITORY" ]]
""",
                    shell=shell,
                    startup=True,
                    env={"ZSH_TEST_REPOSITORY": str(repository)},
                )


if __name__ == "__main__":
    unittest.main(verbosity=2)
