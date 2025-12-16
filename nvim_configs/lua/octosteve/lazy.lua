-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require("lazy").setup({
  -- Telescope for fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Color scheme
  "EdenEast/nightfox.nvim",

  -- Treesitter for better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },

  -- Undo tree visualization
  'mbbill/undotree',

  -- LSP Configuration
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },

  -- Completion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/cmp-nvim-lua' },

  -- Snippets
  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },

  -- UI and workflow
  "roman/golden-ratio",
  "janko-m/vim-test",
  "github/copilot.vim",

  -- Ruby support
  'vim-ruby/vim-ruby',
  'tpope/vim-rails',
  'tpope/vim-rbenv',
  'tpope/vim-bundler',

  -- Git integration
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
})
