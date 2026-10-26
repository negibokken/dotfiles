return {
  "stevearc/profile.nvim",
  lazy = true,
  init = function()
    if vim.env.NVIM_PROFILE and vim.env.NVIM_PROFILE ~= "" then
      require("features.profile").setup()
    end
  end,
  keys = {
    {
      "<F3>",
      function()
        require("features.profile").toggle()
      end,
      mode = { "n", "x", "s", "o" },
      desc = "Toggle profiling",
    },
  },
}
