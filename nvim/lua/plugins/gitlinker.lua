return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = { mappings = nil },
  keys = {
    {
      "<leader>gp",
      function()
        local mode = vim.fn.mode():match("^[vV\22]") and "v" or "n"
        require("gitlinker").get_buf_range_url(
          mode,
          { action_callback = require("gitlinker.actions").copy_to_clipboard }
        )
      end,
      mode = { "n", "x" },
      desc = "Copy GitHub permalink",
    },
  },
}
