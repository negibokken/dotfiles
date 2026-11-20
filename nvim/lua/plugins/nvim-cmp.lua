return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { "hrsh7th/cmp-cmdline" },
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.mapping["<C-e>"] = cmp.mapping.abort()
    opts.mapping["<C-y>"] = cmp.mapping.confirm({ select = true })
    -- Keep Enter as a newline (and preserve MiniPairs' handling).
    opts.mapping["<CR>"] = cmp.mapping(function(fallback)
      fallback()
    end, { "i" })
    opts.experimental.ghost_text = false
  end,
  config = function(_, opts)
    require("lazyvim.util.cmp").setup(opts)
    local cmp = require("cmp")
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = "buffer" } },
    })
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    })
  end,
}
