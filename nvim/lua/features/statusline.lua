local M = {}
local cache = {}

vim.api.nvim_create_autocmd("BufWipeout", {
  group = vim.api.nvim_create_augroup("user_character_count", { clear = true }),
  callback = function(event)
    cache[event.buf] = nil
  end,
})

function M.characters()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "bigfile" then
    return ""
  end
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  if not cache[buf] or cache[buf].tick ~= tick then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    cache[buf] = { tick = tick, text = vim.fn.strchars(table.concat(lines, "")) .. " chars" }
  end
  return cache[buf].text
end

return M
