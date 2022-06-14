local function copilot_keys()
  local suggestion = vim.fn["copilot#GetDisplayedSuggestion"]()
  if suggestion.text ~= '' then
    local copilot_keys = vim.fn["copilot#Accept"]()
    if copilot_keys ~= '' then
      vim.api.nvim_feedkeys(copilot_keys, "i", true)
      return true
    end
  end
  return false
end

local function load(use)
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'simrat39/rust-tools.nvim'

  local lspconfig = require('lspconfig')
  local cmp = require('cmp')

  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ''

  local cmp_opts = {
    mapping = cmp.mapping.preset.insert({
      ['C-Space'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-e>'] = cmp.mapping.abort(),
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif copilot_keys() then
        elseif vim.fn["vsnip#available"](1) > 0 then
          if vim.fn["vsnip#jumpable"](1) > 0 then
            vim.fn.feedkeys(string.format('%c%c%c(vsnip-jump-next)', 0x80, 253, 83))
          end
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
            return
        elseif vim.fn["vsnip#available"](1) > 0 then
          if vim.fn["vsnip#jumpable"](1) > 0 then
            vim.fn.feedkeys(string.format('%c%c%c(vsnip-jump-prev)', 0x80, 253, 83))
          end
        end
        fallback()
      end,
    }),
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  }

  cmp.setup(cmp_opts);

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    })
  })

  local rust_tools_opts = {
    tools = {
      autoSetHints = true,
      hover_with_actions = true,
      inlay_hints = {
        show_parameter_hints = false,
        parameter_hints_prefix = '',
        other_hints_prefix = '',
      },
    },
    server = {
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            command = 'clippy',
          },
        }
      }
    },
  }

  require('rust-tools').setup(rust_tools_opts)

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local servers = { 'tsserver' }
  lspconfig.tsserver.setup {
    capabilities = capabilities,
  }

  vim.diagnostic.config({severity_sort=true})

  vim.fn.sign_define('DiagnosticSignError', {text='', texthl='DiagnosticError', linehl='', numhl=''})
  vim.fn.sign_define('DiagnosticSignWarn', {text='', texthl='DiagnosticWarn', linehl='', numhl=''})
  vim.fn.sign_define('DiagnosticSignHint', {text='', texthl='DiagnosticHint', linehl='', numhl=''})
  vim.fn.sign_define('DiagnosticSignInfo', {text='', texthl='DiagnosticInfo', linehl='', numhl=''})

  local map_key = require('utils').map_key
  map_key('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
  map_key('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
  map_key('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
  map_key('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map_key('n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>')
  map_key('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map_key('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format{ async = true }<CR>')
  map_key('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')

  map_key('n', '<leader>dh', '<cmd>lua vim.diagnostic.open_float()<CR>')
  map_key('n', '<leader>dj', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  map_key('n', '<leader>dk', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  map_key('n', '<leader>dJ', '<cmd>lua vim.diagnostic.goto_next{ severity = { min = vim.diagnostic.severity.WARN } }<CR>')
  map_key('n', '<leader>dK', '<cmd>lua vim.diagnostic.goto_prev{ severity = { min = vim.diagnostic.severity.WARN } }<CR>')

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

