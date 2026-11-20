-- Run using benchmark.py --check nvim/tests/integration.lua --output <result.json>.
local passed = {}
local function test(name, action)
  action()
  passed[#passed + 1] = name
end
local function keys(value)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(value, true, false, true), "xt", false)
end
local function loaded(name)
  local plugin = require("lazy.core.config").plugins[name]
  return plugin and plugin._.loaded ~= nil
end
local files = vim.env.NVIM_BENCH_FIXTURES
local vault = require("config.paths").notes()

test("empty startup defers optional features", function()
  for _, name in ipairs({
    "telescope.nvim",
    "nvim-cmp",
    "obsidian.nvim",
    "profile.nvim",
    "gitlinker.nvim",
    "no-neck-pain.nvim",
  }) do
    assert(not loaded(name), name .. " loaded during empty startup")
  end
  assert(not package.loaded["features.notes"] and not package.loaded["features.files"])
  assert(not require("lazy.core.config").plugins["copilot.vim"])
  assert(not require("lazy.core.config").plugins["coc.nvim"])
  assert(not require("lazy.core.config").plugins["blink.cmp"])
  assert(not Snacks.config.scroll.enabled and not Snacks.config.picker.enabled)
  assert(vim.fn.exists(":Zettelkasten") == 2 and vim.fn.exists(":RenameToH1") == 2)
end)
test("code and Markdown settings remain distinct", function()
  vim.cmd.edit(files .. "/sample.lua")
  assert(vim.bo.filetype == "lua" and not vim.wo.spell)
  vim.cmd.edit(files .. "/sample.md")
  assert(vim.bo.filetype == "markdown" and vim.wo.spell and vim.b.autoformat == false)
  assert(vim.bo.shiftwidth == 4 and not loaded("obsidian.nvim"))
end)
test("nested Vault notes load link completion without Telescope", function()
  vim.fn.mkdir(vault .. "/nested", "p")
  vim.fn.writefile({ "# Example", "", "[[sample]]", "- [ ] task" }, vault .. "/nested/example.md")
  vim.cmd.edit(vault .. "/nested/example.md")
  assert(loaded("obsidian.nvim") and loaded("nvim-cmp") and not loaded("telescope.nvim"))
  local sources = {}
  for _, source in ipairs(require("cmp").get_config().sources) do
    sources[source.name] = true
  end
  for _, name in ipairs({ "obsidian", "obsidian_new", "obsidian_tags", "nvim_lsp", "path", "buffer", "snippets" }) do
    assert(sources[name], "missing completion source: " .. name)
  end
  assert(vim.fn.maparg("gf", "n", false, true).buffer == 1)
  vim.api.nvim_win_set_cursor(0, { 4, 0 })
  require("obsidian").util.toggle_checkbox()
  assert(vim.api.nvim_get_current_line():match("%[x%]"))
  vim.bo.modified = false
end)
test("completion engine preserves insertion and command line behavior", function()
  vim.cmd("enew!")
  vim.bo.filetype = "lua"
  keys("ihello<CR>world<C-j>")
  assert(vim.fn.mode() == "n")
  assert(vim.api.nvim_buf_get_lines(0, 0, -1, false)[2]:match("^%s*world$"))
  assert(vim.fn.maparg("<C-j>", "i", false, true).rhs == "<Esc>")
  local cmp = require("cmp")
  assert(cmp.get_config().mapping["<C-E>"] and cmp.get_config().mapping["<C-Y>"])
  keys(":")
  assert(loaded("cmp-cmdline") and not package.loaded["blink.cmp"])
  keys("<Esc>")
end)
test("line and block comment operators lazy load correctly", function()
  vim.cmd("enew!")
  vim.bo.filetype = "c"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "int value = 1;" })
  keys("gcc")
  assert(
    loaded("Comment.nvim") and vim.api.nvim_get_current_line():find("//", 1, true),
    vim.inspect({
      loaded = loaded("Comment.nvim"),
      text = vim.api.nvim_get_current_line(),
      gc = vim.fn.maparg("gc", "n", false, true),
    })
  )
  keys("gcc")
  assert(vim.api.nvim_get_current_line() == "int value = 1;")
  keys("gbc")
  assert(vim.api.nvim_get_current_line():find("/*", 1, true))
end)
test("icon compatibility and Telescope extensions are available", function()
  local icon = require("nvim-web-devicons").get_icon("sample.lua", "lua")
  assert(icon and not require("lazy.core.config").plugins["nvim-web-devicons"])
  local telescope = require("telescope")
  assert(type(telescope.extensions.live_grep_args.live_grep_args) == "function")
  assert(type(telescope.extensions.fzf.native_fzf_sorter) == "function")
end)
test("centered layout remains available on demand", function()
  vim.cmd("enew!")
  vim.cmd.NoNeckPain()
  assert(loaded("no-neck-pain.nvim"))
  assert(vim.wait(1000, function()
    return _G.NoNeckPain.state and _G.NoNeckPain.state.enabled
  end, 10))
  vim.cmd.NoNeckPain()
  vim.wait(1000, function()
    return not _G.NoNeckPain.state.enabled
  end, 10)
end)
test("profiling can be started on demand", function()
  require("features.profile").toggle()
  local profile = require("profile")
  assert(profile.is_recording())
  profile.stop()
end)
assert(vim.v.errmsg == "", vim.v.errmsg)
return passed
