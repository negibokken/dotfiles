-- 新しいタブを開く
vim.keymap.set("n", "<Leader>tt", ":tab new<CR>", { noremap = true, silent = true })

-- 次のタブに移動
vim.keymap.set("n", "<Leader>tn", ":tab next<CR>", { noremap = true, silent = true })

-- 前のタブに移動
vim.keymap.set("n", "<Leader>tp", ":tab prev<CR>", { noremap = true, silent = true })

-- 現在のタブを閉じる
vim.keymap.set("n", "<Leader>tc", ":tab close | bdelete<CR>", { noremap = true, silent = true })
