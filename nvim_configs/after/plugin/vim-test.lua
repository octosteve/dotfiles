vim.keymap.set("n", "<Leader>t", ":TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<Leader>T", ":TestFile<CR>", { silent = true })
vim.keymap.set("n", "<Leader>taf", ":TestNearest TEST_ALL_FEATURES=1<CR>", { silent = true })
vim.keymap.set("n", "<Leader>Taf", ":TestFile TEST_ALL_FEATURES=1<CR>", { silent = true })
vim.keymap.set("n", "<Leader>a", ":TestSuite<CR>", { silent = true })
vim.keymap.set("n", "<Leader>l", ":TestLast<CR>", { silent = true })
vim.keymap.set("n", "<Leader>g", ":TestVisit<CR>", { silent = true })

vim.g["test#strategy"] = "neovim"
