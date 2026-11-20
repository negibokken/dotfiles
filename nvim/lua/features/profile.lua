local M = {}

function M.setup()
  local mode = vim.env.NVIM_PROFILE
  if not mode or mode == "" then
    return
  end
  local profile = require("profile")
  profile.instrument_autocmds()
  if mode:lower():match("^start") then
    profile.start("*")
  else
    profile.instrument("*")
  end
end

function M.toggle()
  local profile = require("profile")
  if not profile.is_recording() then
    profile.start("*")
    return
  end
  profile.stop()
  vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
    if filename and filename ~= "" then
      profile.export(filename)
      vim.notify("Wrote " .. filename)
    end
  end)
end

return M
