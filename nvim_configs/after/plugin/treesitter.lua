local status_ok, nvim_treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  vim.notify('nvim-treesitter not found', vim.log.levels.WARN)
  return
end

nvim_treesitter.setup {
  ensure_installed = { "elixir", "ruby", "javascript", "typescript", "lua", "vim", "bash" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
