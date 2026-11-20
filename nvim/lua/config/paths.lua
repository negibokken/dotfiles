local M = {}

function M.notes()
  return vim.fs.normalize(vim.fn.expand(vim.env.SECOND_BRAIN or "~/Documents/obsidian/notes"))
end

return M
