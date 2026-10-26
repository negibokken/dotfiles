local M = {}
local pending = {}

function M.create_zettelkasten(visual)
  local directory = require("config.paths").notes() .. "/00--zettelkasten"
  vim.fn.mkdir(directory, "p")
  local id = os.date("%Y%m%d%H%M%S")
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local text = ""
  local start_row, start_col, end_row, end_col
  if visual then
    local first, last = vim.fn.getpos("'<"), vim.fn.getpos("'>")
    start_row, start_col, end_row = first[2] - 1, first[3] - 1, last[2] - 1
    local line = vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, false)[1]
    end_col = vim.fn.byteidx(line, vim.fn.charidx(line, math.min(last[3] - 1, #line)) + 1)
    if vim.fn.visualmode() == "V" then
      start_col, end_col = 0, #line
    end
    if end_col == -1 then
      end_col = #line
    end
    text = table.concat(vim.api.nvim_buf_get_text(buf, start_row, start_col, end_row, end_col, {}), " ")
  else
    start_row, start_col = cursor[1] - 1, cursor[2]
    end_row, end_col = start_row, start_col
  end
  local label = text ~= "" and text or id .. ".md"
  vim.api.nvim_buf_set_text(buf, start_row, start_col, end_row, end_col, { "[[" .. id .. "|" .. label .. "]]" })
  vim.cmd.vsplit(vim.fn.fnameescape(directory .. "/" .. id .. ".md"))
  if visual and text ~= "" then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# " .. text, "" })
  end
end

local function git(root, args, callback)
  local command = vim.list_extend({ "git" }, args)
  local done = vim.schedule_wrap(callback)
  local ok, err = pcall(vim.system, command, { cwd = root, timeout = 10000, text = true }, done)
  if not ok then
    done({ code = 1, stderr = tostring(err) })
  end
end

-- Exclusive creation preserves a file that arrived while git was running.
local function write_missing(path, content)
  if vim.fn.filereadable(path) == 1 then
    return true
  end
  local ok = pcall(vim.fn.mkdir, vim.fs.dirname(path), "p")
  if not ok then
    return false
  end
  local fd, err = vim.uv.fs_open(path, "wx", 420)
  if not fd then
    return err and err:match("EEXIST") ~= nil and vim.fn.filereadable(path) == 1
  end
  local offset = 0
  while offset < #content do
    local count = vim.uv.fs_write(fd, content:sub(offset + 1), offset)
    if not count or count == 0 then
      vim.uv.fs_close(fd)
      vim.uv.fs_unlink(path)
      return false
    end
    offset = offset + count
  end
  vim.uv.fs_close(fd)
  return true
end

function M.open_today()
  local root = require("config.paths").notes()
  local relative = "periodic-notes/daily-notes/" .. os.date("%Y/%m/%Y-%m-%d") .. ".md"
  local path = root .. "/" .. relative
  if vim.fn.filereadable(path) == 1 then
    vim.cmd.edit(vim.fn.fnameescape(path))
    return
  end
  if pending[path] then
    vim.notify("今日のノートを取得中です")
    return
  end
  pending[path] = true
  local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local function finish(success)
    pending[path] = nil
    if not success then
      vim.notify(
        "今日のノートを origin から取得できませんでした。新規ファイルとして開きます",
        vim.log.levels.WARN
      )
    end
    if
      vim.api.nvim_get_current_win() == win
      and vim.api.nvim_get_current_buf() == buf
      and vim.api.nvim_buf_get_changedtick(buf) == tick
      and not vim.bo[buf].modified
      and vim.fn.mode() == "n"
    then
      vim.cmd.edit(vim.fn.fnameescape(path))
    else
      vim.notify((success and "今日のノートを取得しました: " or "今日のノート: ") .. path)
    end
  end
  git(root, { "fetch", "origin", "main" }, function(fetch)
    if fetch.code ~= 0 then
      finish(false)
      return
    end
    git(root, { "show", "origin/main:" .. relative }, function(show)
      finish(show.code == 0 and write_missing(path, show.stdout))
    end)
  end)
end

function M.open_quarterly()
  local year = os.date("%Y")
  local quarter = math.ceil(tonumber(os.date("%m")) / 3)
  local path = string.format(
    "%s/periodic-notes/quarterly-notes/%s/%s-Q%d.md",
    require("config.paths").notes(),
    year,
    year,
    quarter
  )
  vim.cmd.vsplit(vim.fn.fnameescape(path))
end

function M.insert_week()
  local inserting = vim.fn.mode() == "i"
  local today = os.date("*t")
  local first = os.time({ year = today.year, month = 1, day = 1 })
  local days = os.difftime(os.time(today), first) / 86400
  local week = math.floor((days + os.date("*t", first).wday - 1) / 7) + 1
  vim.cmd("normal! aWeek-" .. week)
  if inserting then
    vim.cmd("startinsert!")
  end
end

return M
