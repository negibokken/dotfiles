local M = {}

local function rename(buf, destination)
  local source = vim.api.nvim_buf_get_name(buf)
  if source == destination then
    return
  end
  if vim.uv.fs_lstat(destination) then
    vim.notify("Destination already exists: " .. destination, vim.log.levels.WARN)
    return
  end
  local destination_buf = vim.fn.bufnr(destination)
  if destination_buf ~= -1 and destination_buf ~= buf then
    vim.notify("Destination is already open: " .. destination, vim.log.levels.WARN)
    return
  end
  local ok, err = vim.uv.fs_rename(source, destination)
  if not ok then
    vim.notify("Could not move file: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_name(buf, destination)
  vim.notify("Moved to " .. destination)
end

function M.rename_to_h1()
  local buf = vim.api.nvim_get_current_buf()
  local source = vim.api.nvim_buf_get_name(buf)
  if source == "" then
    vim.notify("Buffer has no associated file", vim.log.levels.WARN)
    return
  end
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local heading = line:match("^#%s+(.+)")
    if heading then
      local name = heading:gsub('[%s/\\:*?"<>|]', "_") .. ".md"
      rename(buf, vim.fs.dirname(source) .. "/" .. name)
      return
    end
  end
  vim.notify("No H1 heading found", vim.log.levels.WARN)
end

function M.move()
  local buf = vim.api.nvim_get_current_buf()
  local source = vim.api.nvim_buf_get_name(buf)
  if source == "" then
    vim.notify("No file opened", vim.log.levels.WARN)
    return
  end
  local cwd = vim.fn.getcwd()
  require("telescope.builtin").find_files({
    prompt_title = "Select Destination Directory",
    cwd = cwd,
    find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git", "." },
    attach_mappings = function(_, map)
      local function select(prompt)
        local entry = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt)
        if entry and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == source then
          rename(buf, vim.fs.joinpath(cwd, entry[1], vim.fs.basename(source)))
        end
      end
      map("i", "<CR>", select)
      map("n", "<CR>", select)
      return true
    end,
  })
end

return M
