vim.g.mapleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

function TrimWhiteSpace()
	vim.api.nvim_command("%s/\\s*$//")
end

vim.keymap.set("n", "<F3>", ":lua TrimWhiteSpace()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>4", "mzgg=G`z", { noremap = true })

vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")
vim.keymap.set("i", "kk", "<ESC>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<Leader>e", ":e <C-R>=vim.fn.expand('%:p:h') . '/'<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>r", ":r <C-R>=vim.fn.expand('%:p:h') . '/'<CR>", { noremap = true })
vim.keymap.set("n", "<Leader><space>", ":nohlsearch<CR>", { noremap = true })
vim.g.mapleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

function TrimWhiteSpace()
	vim.api.nvim_command("%s/\\s*$//")
end

vim.keymap.set("n", "<F3>", ":lua TrimWhiteSpace()<CR>", { noremap = true })

vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")
vim.keymap.set("i", "kk", "<ESC>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<Leader>e", ":e <C-R>=expand('%:p:h') . '/'<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>r", ":r <C-R>=expand('%:p:h') . '/'<CR>", { noremap = true })
vim.keymap.set("n", "<Leader><space>", ":nohlsearch<CR>", { noremap = true })

-- Move selected text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Just `J` but keeps cursor where it started
vim.keymap.set("n", "J", "mzJ`z")

-- Copy to system buffer
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Format Code
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Replace all
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make Terminal sane
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
