-- LSP configuration for nvim 0.11+
-- Setup nvim-cmp
local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  vim.notify('nvim-cmp not found', vim.log.levels.WARN)
  return
end

cmp.setup({
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  },
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- Diagnostic sign icons
local signs = { Error = 'E', Warn = 'W', Hint = 'H', Info = 'I' }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = true,
})

-- Keymaps for LSP
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  local map = vim.keymap.set
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  map("n", "<leader>vd", vim.diagnostic.open_float, opts)
  map("n", "[d", vim.diagnostic.goto_next, opts)
  map("n", "]d", vim.diagnostic.goto_prev, opts)
  map("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  map("n", "<leader>vrr", vim.lsp.buf.references, opts)
  map("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  map("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

-- Get capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- List of servers and their configurations
local servers = {
  eslint = {},
  bashls = {},
  jedi_language_server = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  },
  elixirls = {},
  html = {},
  solargraph = {},
  tailwindcss = {},
  cssls = {},
  dockerls = {},
  emmet_ls = {},
  gopls = {},
  golangci_lint_ls = {},
  jsonls = {},
  marksman = {},
  vimls = {},
  yamlls = {}
}

-- Configure LSP servers using vim.lsp.config (nvim 0.11+)
for server_name, server_config in pairs(servers) do
  local config = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
  }, server_config)
  
  pcall(function()
    vim.lsp.config[server_name] = config
    vim.lsp.enable(server_name)
  end)
end
