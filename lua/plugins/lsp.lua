local function load(use)
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'anott03/nvim-lspinstall'

  local lspconfig = require('lspconfig')
  local completion = require('completion')
  local map_key = require('utils').map_key

  local function custom_on_attach(client)
    print('Attaching to ' .. client.name)
    completion.on_attach(client)
  end

  local default_config = {
    on_attach = custom_on_attach
    -- on_attach = completion.on_attach
  }

  lspconfig.tsserver.setup(default_config)

  map_key('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  map_key('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  map_key('n', '<leader>gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
  map_key('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map_key('n', '<leader>gR', '<cmd>lua vim.lsp.buf.rename()<CR>')
  map_key('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

  -- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  --   vim.lsp.diagnostic.on_publish_diagnostics, {
  --     underline = true,
  --     virtual_text = false,
  --     signs = true,
  --     update_in_insert = true,
  --   }
  -- )
end

return {
  load = load
}
