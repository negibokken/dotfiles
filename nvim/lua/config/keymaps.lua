local map = vim.keymap.set

map("i", "<C-j>", "<Esc>", { desc = "Exit insert mode" })
map("n", "<F1>", "<cmd>edit $MYVIMRC<cr>", { desc = "Edit Neovim configuration" })
map("n", "<leader>cpf", function()
  vim.fn.setreg("+", vim.fn.expand("%:."))
end, { desc = "Copy relative path" })
map("n", "<leader>cpF", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Copy file name" })

map("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>tc", "<cmd>tabclose | bdelete<cr>", { desc = "Close tab and buffer" })

map("n", "<A-z>", "<cmd>Zettelkasten<cr>", { desc = "Create Zettelkasten note" })
map("i", "<A-z>", "<cmd>Zettelkasten<cr><Esc>", { desc = "Create Zettelkasten note" })
map("x", "<A-z>", ":<C-u>lua require('features.notes').create_zettelkasten(true)<cr>", {
  desc = "Create note from selection",
  silent = true,
})
map("n", "<A-c>", function()
  require("features.notes").open_today()
end, { desc = "Open today's note" })
map("n", "<A-q>", function()
  require("features.notes").open_quarterly()
end, { desc = "Open quarterly note" })
map({ "n", "i" }, "<A-w>", function()
  require("features.notes").insert_week()
end, { desc = "Insert week number" })
map("n", "<leader>rn", "<cmd>RenameToH1<cr>", { desc = "Rename file to H1" })
