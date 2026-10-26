local group = vim.api.nvim_create_augroup("user_editor", { clear = true })

-- FocusGained/TermLeave/TermClose are already handled by LazyVim.
-- Check only the current file, at most once per second, outside insert mode.
local last_check = {}
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  group = group,
  callback = function(event)
    local buf = event.buf
    if vim.bo[buf].buftype ~= "" or vim.api.nvim_buf_get_name(buf) == "" then
      return
    end
    local now = vim.uv.hrtime()
    if last_check[buf] and now - last_check[buf] < 1e9 then
      return
    end
    last_check[buf] = now
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_current_buf() == buf and vim.fn.mode() == "n" then
        vim.cmd("checktime " .. buf)
      end
    end)
  end,
})
vim.api.nvim_create_autocmd("BufWipeout", {
  group = group,
  callback = function(event)
    last_check[event.buf] = nil
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function(event)
    vim.b[event.buf].autoformat = false
  end,
})
