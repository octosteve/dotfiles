-- Enable treesitter-based syntax highlighting (built-in to Neovim 0.11+)
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
