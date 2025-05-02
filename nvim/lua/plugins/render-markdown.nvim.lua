return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("render-markdown").setup({
				conceal = {
					level = 2, -- Set conceallevel 2
					syntax = true,
				},
				render_modes = true,
				heading = {
					width = "block",
					left_pad = 0,
					right_pad = 4,
					icons = {},
				},
				code = {
					width = "block",
				},
			})

			-- Set conceallevel automatically when the files is Markdown
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					vim.opt.conceallevel = 2
					vim.opt.concealcursor = "nc" -- Enable normal mode and command mode
				end,
			})
		end,
	},
}
