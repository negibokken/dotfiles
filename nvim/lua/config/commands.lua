-- Register lightweight entry points; feature modules load only on use.
vim.api.nvim_create_user_command("Zettelkasten", function()
  require("features.notes").create_zettelkasten()
end, { desc = "Create and link a Zettelkasten note" })

vim.api.nvim_create_user_command("RenameToH1", function()
  require("features.files").rename_to_h1()
end, { desc = "Rename the current file to its first Markdown heading" })

vim.api.nvim_create_user_command("CodeDiffPR", function(opts)
  require("features.pr_review").open(opts.args)
end, { nargs = 1, desc = "Open a GitHub pull request diff in a worktree" })
