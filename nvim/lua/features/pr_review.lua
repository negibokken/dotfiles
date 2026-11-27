local M = {}
local pending = {}

local function run(cwd, command)
  local thread = coroutine.running()
  vim.system(command, { cwd = cwd, text = true, timeout = 60000, env = { GIT_TERMINAL_PROMPT = "0" } }, function(result)
    vim.schedule(function()
      local ok, err = coroutine.resume(thread, result)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end)
  end)
  return coroutine.yield()
end

local function output(cwd, command)
  local result = run(cwd, command)
  if result.code ~= 0 then
    local detail = vim.trim(result.stderr or "")
    error(detail ~= "" and detail or (command[1] .. " exited with status " .. result.code), 0)
  end
  return vim.trim(result.stdout or "")
end

local function repository(cwd, buffer)
  if vim.bo[buffer].buftype == "" then
    local path = vim.api.nvim_buf_get_name(buffer)
    local directory = path ~= "" and vim.fs.dirname(path) or nil
    if directory and vim.uv.fs_stat(directory) then
      local file_root = run(directory, { "git", "rev-parse", "--show-toplevel" })
      if file_root.code == 0 then
        return vim.trim(file_root.stdout)
      end
    end
  end
  local root = run(cwd, { "git", "rev-parse", "--show-toplevel" })
  if root.code == 0 then
    return vim.trim(root.stdout)
  end
  error("Open a file or directory in a Git repository first", 0)
end

local function get_pull_request(root, number)
  local url = output(root, { "git", "config", "--get", "remote.origin.url" })
  local slug = url:match("^git@github%.com:(.+)$")
    or url:match("^ssh://git@github%.com/(.+)$")
    or url:match("^ssh://git@ssh%.github%.com:443/(.+)$")
    or url:match("^https://github%.com/(.+)$")
  slug = slug and slug:gsub("%.git$", "")
  local owner = slug and slug:match("^([%w-]+)/[%w._-]+$")
  if not owner then
    error("The origin remote must point to a github.com repository", 0)
  end

  local cli = owner:lower() == "negibokken" and "gh-personal" or "gh"
  local pr = vim.json.decode(output(root, {
    cli,
    "api",
    "repos/" .. slug .. "/pulls/" .. number,
    "--jq",
    "{base: .base.ref, base_sha: .base.sha, head_sha: .head.sha}",
  }))
  if
    type(pr) ~= "table"
    or type(pr.base) ~= "string"
    or pr.base == ""
    or type(pr.base_sha) ~= "string"
    or #pr.base_sha ~= 40
    or not pr.base_sha:match("^%x+$")
    or type(pr.head_sha) ~= "string"
    or #pr.head_sha ~= 40
    or not pr.head_sha:match("^%x+$")
  then
    error("GitHub did not return the PR's base branch and commit IDs", 0)
  end
  return pr
end

local function review_worktree(root, number, head)
  local branch = ("codex/review-pr-%s-%s"):format(number, head:sub(1, 12))
  local exists = run(root, { "git", "show-ref", "--verify", "--quiet", "refs/heads/" .. branch }).code == 0
  local args = { "git", "wt", "--nocd", "--copyignored=false", "--copymodified=false", "--copyuntracked=false", branch }
  if not exists then
    args[#args + 1] = head
  end
  local path = output(root, args):match("[^\n]+$")
  if not path or output(path, { "git", "rev-parse", "HEAD" }) ~= head then
    error("The review worktree is on a different commit" .. (path and (": " .. path) or ""), 0)
  end
  if output(path, { "git", "status", "--porcelain", "--untracked-files=all" }) ~= "" then
    error("The review worktree has local changes: " .. path, 0)
  end
  local prefix = (vim.uv.fs_realpath(path) or path) .. "/"
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].modified then
      local name = vim.api.nvim_buf_get_name(buf)
      if vim.startswith(vim.uv.fs_realpath(name) or name, prefix) then
        error("The review worktree has unsaved buffers: " .. path, 0)
      end
    end
  end
  return path
end

function M.open(number)
  if not number:match("^[1-9]%d*$") then
    vim.notify("Usage: :CodeDiffPR <pull request number>", vim.log.levels.ERROR)
    return
  end

  local cwd, buffer = vim.fn.getcwd(), vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  coroutine.wrap(function()
    local key
    local ok, err = pcall(function()
      local root = repository(cwd, buffer)
      local request = root .. ":" .. number
      if pending[request] then
        return
      end
      key = request
      pending[key] = true
      vim.notify("Preparing worktree for PR #" .. number)

      local pr = get_pull_request(root, number)
      output(root, {
        "git",
        "fetch",
        "--no-tags",
        "--no-write-fetch-head",
        "--no-recurse-submodules",
        "--refmap=",
        "origin",
        "refs/heads/" .. pr.base,
        ("refs/pull/%s/head"):format(number),
      })
      local base = output(root, { "git", "merge-base", pr.base_sha, pr.head_sha })
      local path = review_worktree(root, number, pr.head_sha)
      if vim.api.nvim_get_current_win() ~= win or vim.api.nvim_get_current_buf() ~= buffer then
        vim.notify("PR #" .. number .. " worktree is ready: " .. path)
        return
      end
      vim.api.nvim_cmd({ cmd = "CodeDiff", args = { "--repo", path, "--side-by-side", base } }, {})
    end)
    if key then
      pending[key] = nil
    end
    if not ok then
      vim.notify("CodeDiffPR #" .. number .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
  end)()
end

return M
