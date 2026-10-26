return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = { { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" } },
  opts = function(_, opts)
    local actions = require("telescope.actions")
    opts.defaults.mappings.i["<C-n>"] = actions.move_selection_next
    opts.defaults.mappings.i["<C-p>"] = actions.move_selection_previous
    opts.defaults.mappings.i["<C-c>"] = actions.close
  end,
  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Live Grep (arguments)",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find Buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Find Help",
    },
    {
      "<leader>tr",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>mv",
      function()
        require("features.files").move()
      end,
      desc = "Move current file",
    },
  },
}
