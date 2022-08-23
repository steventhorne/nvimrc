local function configure()
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  local lsp_signature_opts = {
    floating_window = false,
    floating_window_off_y = -2,
    close_timeout = 2000,
    hint_enable = false,
  }
  require("lsp_signature").setup(lsp_signature_opts)

  local rust_tools_opts = {
    tools = {
      autoSetHints = true,
      -- hover_with_actions = true, -- https://github.com/simrat39/rust-tools.nvim#setup
      inlay_hints = {
        show_parameter_hints = false,
        parameter_hints_prefix = "",
        other_hints_prefix = "",
      },
    },
    server = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        }
      },
    },
  }

  require("rust-tools").setup(rust_tools_opts)

  local capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        }
      }
    }
  }
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  local pid = vim.fn.getpid()
  local configPath = vim.fn.stdpath("config")
  local nodeModulesPath = configPath.."/node_modules"

  local angularlsCmd = {
    "node",
    nodeModulesPath.."/@angular/language-server/index.js",
    "--stdio",
    "--tsProbeLocations",
    nodeModulesPath,
    "--ngProbeLocations",
    nodeModulesPath,
    "--includeCompletionsWithSnippetText",
    "--includeAutomaticOptionalChainCompletions",
  }
  lspconfig.angularls.setup({
    cmd = angularlsCmd,
    capabilities = capabilities,
    root_dir = util.root_pattern("angular.json"),
    on_new_config = function(new_config)
      new_config.cmd = angularlsCmd
    end
  })

  lspconfig.tsserver.setup({
    capabilities = capabilities,
    cmd = { "node", nodeModulesPath.."/typescript-language-server/lib/cli.js", "--stdio" },
  })

  lspconfig.html.setup({
    capabilities = capabilities,
    cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-html-language-server", "--stdio" },
  })

  lspconfig.cssls.setup({
    capabilities = capabilities,
    cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-css-language-server", "--stdio" },
  })

  lspconfig.svelte.setup({
    capabilities = capabilities,
    cmd = { "node", nodeModulesPath.."/svelte-language-server/bin/server.js", "--stdio" },
  })

  lspconfig.astro.setup({
    capabilities = capabilities,
    cmd = { "node", nodeModulesPath.."/@astrojs/language-server/bin/nodeServer.js", "--stdio" },
    root_dir = util.root_pattern("package.json"),
  })

  lspconfig.omnisharp.setup({
    capabilities = capabilities,
    -- on_attach = function(_, bufnr)
    --   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "cmp#omnifunc")
    -- end,
    cmd = { "E:\\Programs\\OmniSharp\\OmniSharp.exe", "--languageserver", "--hostPID", tostring(pid) },
  })

  lspconfig.sumneko_lua.setup({
    capabilities = capabilities,
    cmd = { "E:\\Programs\\LuaLanguageServer\\bin\\lua-language-server.exe" },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          maxPreload = 2000,
          preloadFileSize = 1000
        },
        telemetry = {
          enabled = false,
        },
      },
    },
  })

  vim.diagnostic.config({ severity_sort=true })

  vim.fn.sign_define("DiagnosticSignError", { text="", texthl="DiagnosticError", linehl="", numhl="" })
  vim.fn.sign_define("DiagnosticSignWarn", { text="", texthl="DiagnosticWarn", linehl="", numhl="" })
  vim.fn.sign_define("DiagnosticSignHint", { text="", texthl="DiagnosticHint", linehl="", numhl="" })
  vim.fn.sign_define("DiagnosticSignInfo", { text="", texthl="DiagnosticInfo", linehl="", numhl="" })

  local map_key = require("utils").map_key
  map_key("n", "<LEADER>ld", ":Telescope lsp_definitions<CR>")
  map_key("n", "<LEADER>lr", ":Telescope lsp_references<CR>")
  map_key("n", "<LEADER>lh", "<CMD>lua vim.lsp.buf.hover()<CR>")
  map_key("n", "<LEADER>li", ":Telescope lsp_implementations<CR>")
  map_key("n", "<LEADER>lR", "<CMD>lua vim.lsp.buf.rename()<CR>")
  map_key("n", "<LEADER>ls", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
  map_key("n", "<LEADER>lf", "<CMD>lua vim.lsp.buf.format()<CR>")
  map_key("n", "<LEADER>la", "<CMD>lua vim.lsp.buf.code_action()<CR>")

  map_key("n", "<LEADER>dh", "<CMD>lua vim.diagnostic.open_float()<CR>")
  map_key("n", "<LEADER>dj", "<CMD>lua vim.diagnostic.goto_next()<CR>")
  map_key("n", "<LEADER>dk", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
  map_key("n", "<LEADER>dJ", "<CMD>lua vim.diagnostic.goto_next{ severity = { min = vim.diagnostic.severity.WARN } }<CR>")
  map_key("n", "<LEADER>dK", "<CMD>lua vim.diagnostic.goto_prev{ severity = { min = vim.diagnostic.severity.WARN } }<CR>")
end

return {
  config = configure
}
