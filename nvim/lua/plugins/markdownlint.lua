local HOME = os.getenv("HOME")
return {
	"mfussenegger/nvim-lint",
	optional = true,
	opts = {
		linters_by_ft = {
			markdown = { "markdownlint-cli2" },
		},
		linters = {
			["markdownlint-cli2"] = {
				args = {
					"--config",
					HOME .. "/dotfiles/nvim/lua/plugins/markdownlint/.markdownlint.yaml",
					"--",
				},
			},
		},
	},
}
