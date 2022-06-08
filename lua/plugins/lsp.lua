local function load(use)
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  local lspconfig = require('lspconfig')
  local cmp = require('cmp')

  local function custom_on_attach(client)
    print('Attaching to ' .. client.name)
  end

  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ''

  cmp.setup({
    mapping = {
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) > 0 then
          -- handle vsnip
        else
          local copilot_keys = vim.fn["copilot#Accept"]()
          if copilot_keys ~= "" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
          else
            fallback()
          end
        end
      end
    },
    snippet = {
    },
    window = {
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local servers = { 'tsserver' }
  for _, server in ipairs(servers) do
    lspconfig[server].setup {
      capabilities = capabilities
    }
  end

  local map_key = require('utils').map_key
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

