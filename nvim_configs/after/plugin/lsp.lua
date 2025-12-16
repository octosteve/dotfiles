-- Install the following plugins if you haven't:
--   'neovim/nvim-lspconfig'
--   'hrsh7th/nvim-cmp'
--   'hrsh7th/cmp-nvim-lsp'

-- Use the new lspconfig API for nvim 0.11+
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
  vim.notify('nvim-lspconfig not found', vim.log.levels.ERROR)
  return
end

-- Setup nvim-cmp
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  },
  sources = {
    { name = 'nvim_lsp' },
    -- add more sources as needed
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

-- List of servers
local servers = {
  'eslint', 'bashls', 'jedi_language_server', 'lua_ls', 'elixirls',
  'html', 'solargraph', 'tailwindcss', 'cssls', 'dockerls', 'emmet_ls',
  'gopls', 'golangci_lint_ls', 'jsonls', 'marksman', 'vimls', 'yamlls'
}

-- Setup servers
for _, server in ipairs(servers) do
  local opts = { on_attach = on_attach, capabilities = require('cmp_nvim_lsp').default_capabilities() }
  -- Custom settings for lua_ls
  if server == 'lua_ls' or server == 'sumneko_lua' then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  end
  lspconfig[server].setup(opts)
end
