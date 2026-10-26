#!/usr/bin/env python3
"""Measure startup and first/repeated actions in a real, temporary Neovim UI."""

import argparse
import errno
import fcntl
import json
import os
import pty
import select
import statistics
import struct
import subprocess
import tempfile
import termios
import time
from pathlib import Path

SESSION = r"""
local started = vim.uv.hrtime()
local ready
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.schedule(function() ready = (vim.uv.hrtime() - started) / 1e6 end)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      local ok, result = xpcall(function()
        local loaded = {}
        for name, plugin in pairs(require("lazy.core.config").plugins) do
          if plugin._.loaded then loaded[#loaded + 1] = name end
        end
        table.sort(loaded)
        local result = { ready_ms = ready, loaded = loaded, actions = {} }
        local function measure(name, action)
          local before = vim.uv.hrtime()
          action()
          vim.cmd("redraw")
          result.actions[name] = (vim.uv.hrtime() - before) / 1e6
        end
        if vim.env.NVIM_BENCH_ACTIONS == "1" then
          for n = 1, 2 do
            measure("search_" .. n, function()
              require("telescope.builtin").find_files({ cwd = vim.env.NVIM_BENCH_FIXTURES })
              assert(vim.wait(3000, function()
                local picker = require("telescope.actions.state").get_current_picker(vim.api.nvim_get_current_buf())
                return picker and picker.manager and picker.manager:num_results() > 0
              end, 5), "Telescope results timed out")
              require("telescope.actions").close(vim.api.nvim_get_current_buf())
              vim.cmd("stopinsert")
            end)
          end
          for n = 1, 2 do
            measure("oil_" .. n, function()
              require("oil").open(vim.env.NVIM_BENCH_FIXTURES)
              assert(vim.wait(3000, function()
                return vim.bo.filetype == "oil" and vim.api.nvim_buf_line_count(0) > 1
              end, 5), "Oil entries timed out")
            end)
            vim.cmd("enew!")
          end
          local files = {}
          for _, name in ipairs({ "sample.lua", "sample.md" }) do
            vim.cmd.edit(vim.env.NVIM_BENCH_FIXTURES .. "/" .. name)
            files[#files + 1] = vim.api.nvim_get_current_buf()
          end
          local switches = {}
          for n = 1, 40 do
            local before = vim.uv.hrtime()
            vim.api.nvim_set_current_buf(files[n % 2 + 1])
            vim.cmd("redraw")
            switches[#switches + 1] = (vim.uv.hrtime() - before) / 1e6
          end
          table.sort(switches)
          result.actions.buffer_switch = switches[20]
        end
        if vim.env.NVIM_BENCH_CHECKS and vim.env.NVIM_BENCH_CHECKS ~= "" then
          result.checks = dofile(vim.env.NVIM_BENCH_CHECKS)
        end
        result.messages = vim.fn.execute("messages")
        return result
      end, debug.traceback)
      vim.fn.writefile({ vim.json.encode(ok and result or { error = result }) }, vim.env.NVIM_BENCH_OUTPUT)
      vim.cmd("qa!")
    end, 350)
  end,
})
"""


def run(config, fixtures, vault, state, target, actions, checks=None):
    config_link = state / "config" / "nvim"
    config_link.unlink(missing_ok=True)
    config_link.symlink_to(config.resolve(), target_is_directory=True)
    output = state / "result.json"
    startup = state / "startup.log"
    output.unlink(missing_ok=True)
    startup.unlink(missing_ok=True)
    # Use the installed, locked plugin versions without installing/updating anything.
    shim = """
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
local lazy = require("lazy")
local setup = lazy.setup
lazy.setup = function(opts)
  opts.checker = { enabled = false }
  opts.change_detection = { enabled = false }
  opts.install = vim.tbl_extend("force", opts.install or {}, { missing = false })
  opts.local_spec = false
  opts.spec[#opts.spec + 1] = {
    "epwalsh/obsidian.nvim",
    opts = { workspaces = { { name = "benchmark", path = vim.env.SECOND_BRAIN } } },
  }
  return setup(opts)
end
"""
    args = [
        "nvim",
        "-i",
        "NONE",
        "--startuptime",
        str(startup),
        "--cmd",
        "lua " + shim,
        "--cmd",
        "lua " + SESSION,
    ]
    if target:
        args.append(str(target))
    env = os.environ.copy()
    env.update(
        XDG_CONFIG_HOME=str(state / "config"),
        NVIM_BENCH_OUTPUT=str(output),
        NVIM_BENCH_FIXTURES=str(fixtures),
        NVIM_BENCH_ACTIONS="1" if actions else "0",
        NVIM_BENCH_CHECKS=str(checks.resolve()) if checks else "",
        SECOND_BRAIN=str(vault),
        TERM="xterm-256color",
    )
    env.pop("NVIM_APPNAME", None)
    env.pop("NVIM", None)
    # In Lua an empty string is truthy; unset this to benchmark normal startup.
    env.pop("NVIM_PROFILE", None)
    master, slave = pty.openpty()
    fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack("HHHH", 40, 120, 0, 0))
    process = subprocess.Popen(
        args, stdin=slave, stdout=slave, stderr=slave, env=env, cwd=fixtures
    )
    os.close(slave)
    deadline = time.monotonic() + 20
    try:
        while process.poll() is None:
            if time.monotonic() >= deadline:
                raise TimeoutError("Neovim benchmark timed out")
            if select.select([master], [], [], 0.05)[0]:
                try:
                    os.read(master, 65536)
                except OSError as error:
                    if error.errno != errno.EIO:
                        raise
                    break
        process.wait(timeout=2)
    finally:
        if process.poll() is None:
            process.kill()
            process.wait()
        os.close(master)
    if process.returncode != 0 or not output.exists():
        raise RuntimeError(
            f"Neovim exited {process.returncode} without benchmark output"
        )
    result = json.loads(output.read_text())
    if "error" in result:
        raise RuntimeError(result["error"])
    if "ready_ms" not in result:
        raise RuntimeError("LazyVim did not finish VeryLazy initialization")
    for line in startup.read_text().splitlines():
        if "NVIM STARTED" in line:
            result["startup_ms"] = float(line.split()[0])
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--config", type=Path, default=Path(__file__).resolve().parents[1]
    )
    parser.add_argument("--runs", type=int, default=10)
    parser.add_argument(
        "--compare-config", type=Path, help="Alternate with this baseline configuration"
    )
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--check", type=Path, help="Run a Lua integration check once in the real UI"
    )
    options = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="nvim-bench-") as directory:
        state = Path(directory)
        (state / "config").mkdir()
        fixtures = state / "files"
        fixtures.mkdir()
        (fixtures / "sample.lua").write_text("local value = 1\n" * 100)
        (fixtures / "sample.md").write_text(
            "# Sample\n\n日本語のノート sample text.\n" * 100
        )
        vault = state / "vault"
        vault.mkdir()
        (vault / "sample.md").write_text((fixtures / "sample.md").read_text())
        if options.check:
            result = run(
                options.config, fixtures, vault, state, None, False, options.check
            )
            options.output.parent.mkdir(parents=True, exist_ok=True)
            options.output.write_text(
                json.dumps(result, ensure_ascii=False, indent=2) + "\n"
            )
            print(json.dumps(result, ensure_ascii=False, indent=2), flush=True)
            return
        configurations = {"after": options.config}
        if options.compare_config:
            configurations = {"before": options.compare_config, **configurations}
        results = {label: {} for label in configurations}
        for name, target in [
            ("empty", None),
            ("lua", fixtures / "sample.lua"),
            ("markdown", fixtures / "sample.md"),
            ("vault", vault / "sample.md"),
        ]:
            samples = {label: [] for label in configurations}
            # Reverse every other pair to balance warm caches and changing host load.
            for number in range(options.runs):
                order = list(configurations.items())
                if number % 2:
                    order.reverse()
                for label, config in order:
                    samples[label].append(
                        run(config, fixtures, vault, state, target, False)
                    )
            for label, values in samples.items():
                results[label][name] = {
                    "startup_median_ms": statistics.median(
                        sample["startup_ms"] for sample in values
                    ),
                    "ready_median_ms": statistics.median(
                        sample["ready_ms"] for sample in values
                    ),
                    "samples": values,
                }
                print(
                    label,
                    name,
                    {
                        key: value
                        for key, value in results[label][name].items()
                        if key != "samples"
                    },
                    flush=True,
                )
        for label, config in configurations.items():
            samples = [
                run(config, fixtures, vault, state, None, True) for _ in range(3)
            ]
            results[label]["actions"] = {
                "medians_ms": {
                    name: statistics.median(
                        sample["actions"][name] for sample in samples
                    )
                    for name in samples[0]["actions"]
                },
                "samples": samples,
            }
            print(label, "actions", results[label]["actions"]["medians_ms"], flush=True)
        if not options.compare_config:
            results = results["after"]
        options.output.parent.mkdir(parents=True, exist_ok=True)
        options.output.write_text(
            json.dumps(results, ensure_ascii=False, indent=2) + "\n"
        )


if __name__ == "__main__":
    main()
