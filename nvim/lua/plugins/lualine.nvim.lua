return {
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local function get_words()
				local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
				local content = table.concat(lines, "")
				local count = vim.fn.strchars(content)
				return count .. " chars"
			end

			table.insert(opts.sections.lualine_z, { get_words })
		end,
	},
}
