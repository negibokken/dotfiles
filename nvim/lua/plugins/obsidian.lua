local vault = require("config.paths").notes()

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  cmd = {
    "ObsidianCheck",
    "ObsidianToggleCheckbox",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianTomorrow",
    "ObsidianDailies",
    "ObsidianNew",
    "ObsidianOpen",
    "ObsidianBacklinks",
    "ObsidianSearch",
    "ObsidianTags",
    "ObsidianTemplate",
    "ObsidianNewFromTemplate",
    "ObsidianQuickSwitch",
    "ObsidianLinkNew",
    "ObsidianLink",
    "ObsidianLinks",
    "ObsidianFollowLink",
    "ObsidianWorkspace",
    "ObsidianRename",
    "ObsidianPasteImg",
    "ObsidianExtractNote",
    "ObsidianDebug",
    "ObsidianTOC",
  },
  event = { "BufReadPre " .. vault .. "/*.md", "BufNewFile " .. vault .. "/*.md" },
  dependencies = {
    "nvim-lua/plenary.nvim",

    "hrsh7th/nvim-cmp",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = vault,
      },
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ["<A-Enter>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    open_notes_in = "vsplit",

    note_frontmatter_func = function(note)
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,

    markdown_link_func = function(opts)
      return require("obsidian.util").markdown_link(opts)
    end,

    preferred_link_style = "wiki",

    follow_url_func = function(url)
      vim.ui.open(url) -- need Neovim 0.10.0+
    end,
  },
}
