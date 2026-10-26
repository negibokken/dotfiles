-- nvim --headless --clean -l nvim/tests/features.lua
local config = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(config)
local root = vim.fn.tempname() .. " with spaces"
vim.fn.mkdir(root, "p")
root = vim.uv.fs_realpath(root)
local native_system, native_notify = vim.system, vim.notify
local notifications = {}
vim.notify = function(message, level)
  notifications[#notifications + 1] = { message = message, level = level }
end
local passed = 0
local function test(name, action)
  action()
  passed = passed + 1
  print("PASS " .. name)
end

local function fixture(name)
  vim.cmd("silent! only!")
  vim.cmd("enew!")
  vim.env.SECOND_BRAIN = root .. "/" .. name
  vim.fn.mkdir(vim.env.SECOND_BRAIN, "p")
  notifications = {}
  return vim.env.SECOND_BRAIN .. "/periodic-notes/daily-notes/" .. os.date("%Y/%m/%Y-%m-%d") .. ".md"
end

local calls
local function mock(responses, delay)
  calls = {}
  vim.system = function(command, opts, callback)
    calls[#calls + 1] = command
    assert(command[1] == "git" and opts.timeout == 10000 and opts.cwd == vim.env.SECOND_BRAIN)
    local response = table.remove(responses, 1)
    assert(response, "unexpected git invocation")
    vim.defer_fn(function()
      callback(response)
    end, delay or 10)
    return {
      wait = function()
        error("Git must never block the UI")
      end,
    }
  end
end
local function settle()
  vim.wait(150, function()
    return false
  end, 5)
end

local ok, err = xpcall(function()
  local notes = require("features.notes")
  test("existing daily note opens without git", function()
    local path = fixture("existing")
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    vim.fn.writefile({ "existing" }, path)
    mock({})
    notes.open_today()
    assert(#calls == 0 and vim.api.nvim_buf_get_name(0) == path)
  end)
  test("fetch is asynchronous and duplicate requests are coalesced", function()
    local path = fixture("success")
    mock({ { code = 0 }, { code = 0, stdout = "# 日本語\n" } }, 30)
    local responsive = false
    vim.defer_fn(function()
      responsive = true
    end, 1)
    notes.open_today()
    notes.open_today()
    assert(#calls == 1 and vim.api.nvim_buf_get_name(0) ~= path)
    assert(vim.wait(1000, function()
      return vim.api.nvim_buf_get_name(0) == path
    end, 5))
    assert(responsive and #calls == 2 and calls[2][2] == "show")
    assert(vim.fn.readfile(path)[1] == "# 日本語")
  end)
  for _, code in ipairs({ 1, 124 }) do
    test("fetch failure/timeout " .. code .. " opens a new buffer", function()
      local path = fixture("failure" .. code)
      mock({ { code = code } })
      notes.open_today()
      assert(vim.wait(1000, function()
        return vim.api.nvim_buf_get_name(0) == path
      end, 5))
      assert(vim.fn.filereadable(path) == 0 and #calls == 1)
      assert(notifications[1].level == vim.log.levels.WARN)
    end)
  end
  test("missing remote note falls back without writing a file", function()
    local path = fixture("missing remote")
    mock({ { code = 0 }, { code = 128 } })
    notes.open_today()
    assert(vim.wait(1000, function()
      return vim.api.nvim_buf_get_name(0) == path
    end, 5))
    assert(vim.fn.filereadable(path) == 0)
  end)
  test("a concurrent local file is never overwritten", function()
    local path = fixture("race")
    mock({ { code = 0 }, { code = 0, stdout = "remote\n" } }, 30)
    notes.open_today()
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    vim.fn.writefile({ "local" }, path)
    settle()
    assert(vim.fn.readfile(path)[1] == "local")
  end)
  test("completion does not steal a different buffer", function()
    local path = fixture("switched")
    mock({ { code = 0 }, { code = 0, stdout = "remote\n" } })
    notes.open_today()
    vim.cmd("enew!")
    local current = vim.api.nvim_get_current_buf()
    settle()
    assert(vim.api.nvim_get_current_buf() == current and vim.fn.filereadable(path) == 1)
  end)
  test("completion preserves edits made while fetching", function()
    fixture("editing")
    mock({ { code = 0 }, { code = 0, stdout = "remote\n" } })
    notes.open_today()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unsaved edits" })
    local current = vim.api.nvim_get_current_buf()
    settle()
    assert(vim.api.nvim_get_current_buf() == current and vim.api.nvim_get_current_line() == "unsaved edits")
  end)
  test("process launch errors release the pending request", function()
    local path = fixture("launch error")
    vim.system = function()
      error("cannot start git")
    end
    notes.open_today()
    assert(vim.wait(1000, function()
      return vim.api.nvim_buf_get_name(0) == path
    end, 5))
    vim.cmd("enew!")
    mock({ { code = 1 } })
    notes.open_today()
    assert(vim.wait(1000, function()
      return vim.api.nvim_buf_get_name(0) == path
    end, 5))
    assert(#calls == 1)
  end)
  test("real local git fetch retrieves a note without changing the index", function()
    local path = fixture("local git")
    vim.system = native_system
    local origin = root .. "/origin"
    vim.fn.mkdir(origin, "p")
    local function git(cwd, args)
      local result = native_system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
      assert(result.code == 0, result.stderr)
      return result.stdout
    end
    git(origin, { "init", "-b", "main" })
    local relative = path:sub(#vim.env.SECOND_BRAIN + 2)
    vim.fn.mkdir(vim.fs.dirname(origin .. "/" .. relative), "p")
    vim.fn.writefile({ "# real git" }, origin .. "/" .. relative)
    git(origin, { "add", "--", relative })
    git(
      origin,
      { "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "--no-gpg-sign", "-m", "fixture" }
    )
    git(vim.env.SECOND_BRAIN, { "init", "-b", "main" })
    git(vim.env.SECOND_BRAIN, { "remote", "add", "origin", origin })
    notes.open_today()
    assert(vim.wait(3000, function()
      return vim.api.nvim_buf_get_name(0) == path
    end, 5))
    assert(vim.fn.readfile(path)[1] == "# real git")
    assert(git(vim.env.SECOND_BRAIN, { "ls-files", "--stage" }) == "")
  end)
  test("character count is cached by buffer and changedtick", function()
    vim.cmd("enew!")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "日本語", "abc" })
    local status = require("features.statusline")
    assert(status.characters() == "6 chars")
    local original = vim.api.nvim_buf_get_lines
    vim.api.nvim_buf_get_lines = function()
      error("unchanged text must not be rescanned")
    end
    assert(status.characters() == "6 chars")
    vim.api.nvim_buf_get_lines = original
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { "日本" })
    assert(status.characters() == "5 chars")
    vim.bo.filetype = "bigfile"
    assert(status.characters() == "")
  end)
  test("idle checks reload the current externally edited file", function()
    vim.cmd("enew!")
    vim.opt.autoread = true
    require("config.autocmds")
    local file = root .. "/reload.md"
    vim.fn.writefile({ "before" }, file)
    vim.cmd.edit(vim.fn.fnameescape(file))
    vim.wait(1050, function()
      return false
    end, 10)
    vim.fn.writefile({ "after external edit", "second line" }, file)
    vim.api.nvim_exec_autocmds("CursorHold", { modeline = false })
    assert(vim.wait(1000, function()
      return vim.api.nvim_get_current_line() == "after external edit"
    end, 5))
  end)
  test("renaming preserves unsaved content and protects existing destinations", function()
    vim.cmd("enew!")
    local source = root .. "/original note.md"
    vim.fn.writefile({ "# Old" }, source)
    vim.cmd.edit(vim.fn.fnameescape(source))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# 日本語 heading", "unsaved" })
    require("features.files").rename_to_h1()
    assert(vim.api.nvim_buf_get_name(0) == root .. "/日本語_heading.md")
    assert(vim.bo.modified and vim.api.nvim_buf_get_lines(0, 1, 2, false)[1] == "unsaved")
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { "# destination" })
    vim.fn.writefile({ "existing" }, root .. "/destination.md")
    require("features.files").rename_to_h1()
    assert(vim.fn.readfile(root .. "/destination.md")[1] == "existing")
    assert(vim.api.nvim_buf_get_name(0) == root .. "/日本語_heading.md")
  end)
  test("renaming protects an unsaved destination buffer", function()
    vim.opt.hidden = true
    vim.cmd("enew!")
    local destination = root .. "/open_destination.md"
    vim.api.nvim_buf_set_name(0, destination)
    local existing = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(existing, 0, -1, false, { "unsaved destination" })
    vim.cmd("enew!")
    local source = root .. "/rename source.md"
    vim.fn.writefile({ "# open_destination" }, source)
    vim.cmd.edit(vim.fn.fnameescape(source))
    require("features.files").rename_to_h1()
    assert(vim.api.nvim_buf_get_name(0) == source and vim.fn.filereadable(source) == 1)
    assert(vim.api.nvim_buf_get_lines(existing, 0, -1, false)[1] == "unsaved destination")
  end)
end, debug.traceback)

vim.system, vim.notify = native_system, native_notify
pcall(vim.api.nvim_del_augroup_by_name, "user_editor")
vim.cmd("silent! %bwipeout!")
vim.wait(20, function()
  return false
end, 1)
vim.fn.delete(root, "rf")
if not ok then
  print(err)
  vim.cmd("cquit 1")
end
print("PASS " .. passed .. " feature scenarios")
vim.cmd("qa!")
