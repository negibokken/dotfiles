return {
	"hrsh7th/nvim-cmp",
	enabled = true,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-cmdline",
	},
	config = function()
		require("cmp").setup({})
	end,
	event = { "InsertEnter", "CmdlineEnter" },
	lazy = true,
}
