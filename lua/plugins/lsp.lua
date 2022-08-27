local function configure()
  local lsp_signature_opts = {
    floating_window = false,
    close_timeout = 2000,
    hint_enable = true,
    hint_prefix = "",
  }
  require("lsp_signature").setup(lsp_signature_opts)

  local rust_tools_opts = {
    tools = {
      autoSetHints = true,
      -- hover_with_actions = true, -- https://github.com/simrat39/rust-tools.nvim#setup
      inlay_hints = {
        auto = true,
        show_parameter_hints = false,
        parameter_hints_prefix = "",
        other_hints_prefix = ": ",
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


  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  default_capabilities.textDocument.completion.completionItem.snippetSupport = true
  default_capabilities = require("cmp_nvim_lsp").update_capabilities(default_capabilities)

  local pid = vim.fn.getpid()
  local configPath = vim.fn.stdpath("config")
  local nodeModulesPath = configPath.."/node_modules"

  local au_lsp = vim.api.nvim_create_augroup("LSP", { clear = true })

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
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = {
      "typescript",
      "html",
      "typescriptreact",
      "typescript.tsx",
    },
    callback = function()
      if vim.fn.expand("%:e") == ".cshtml" then
        return
      end
      local root_dir = require("utils").get_root_dir({ "angular.json" })
      if root_dir ~= nil then
        vim.b.angularls_enabled = true
        vim.b.capabilities = default_capabilities
        vim.lsp.start({
          name = "angularls",
          cmd = angularlsCmd,
          capabilities = default_capabilities,
          root_dir = root_dir,
          on_new_config = function(new_config)
            new_config.cmd = angularlsCmd
          end,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    callback = function()
      local root_dir = require("utils").get_root_dir({ "package.json", "tsconfig.json", "jsconfig.json" })
      vim.lsp.start({
        name = "tsserver",
        cmd = { "node", nodeModulesPath.."/typescript-language-server/lib/cli.js", "--stdio" },
        capabilities = default_capabilities,
        root_dir = root_dir,
        init_options = { hostInfo = "neovim" },
        on_attach = function(client, _)
          if vim.b.angularls_enabled then
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.renameProvider = false
          end
        end
      })
    end,
  })

  -- lspconfig.html.setup({
  --   capabilities = default_capabilities,
  --   cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-html-language-server", "--stdio" },
  -- })
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = "html",
    callback = function()
      local root_dir = require("utils").get_root_dir({ "package.json", ".git" }, true)
      vim.lsp.start({
        name = "html",
        cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-html-language-server", "--stdio" },
        capabilities = default_capabilities,
        root_dir = root_dir,
      })
    end,
  })

  -- lspconfig.cssls.setup({
  --   capabilities = default_capabilities,
  --   cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-css-language-server", "--stdio" },
  -- })
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = { "css", "less", "scss" },
    callback = function()
      local root_dir = require("utils").get_root_dir({ "package.json", ".git" }, true)
      vim.lsp.start({
        name = "css",
        cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-css-language-server", "--stdio" },
        capabilities = default_capabilities,
        root_dir = root_dir,
      })
    end,
  })

  -- lspconfig.svelte.setup({
  --   capabilities = default_capabilities,
  --   cmd = { "node", nodeModulesPath.."/svelte-language-server/bin/server.js", "--stdio" },
  -- })
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = "svelte",
    callback = function()
      local root_dir = require("utils").get_root_dir({ "package.json", ".git" })
      vim.lsp.start({
        name = "svelte",
        cmd = { "node", nodeModulesPath.."/svelte-language-server/bin/server.js", "--stdio" },
        capabilities = default_capabilities,
        root_dir = root_dir,
      })
    end,
  })

  -- lspconfig.astro.setup({
  --   capabilities = default_capabilities,
  --   cmd = { "node", nodeModulesPath.."/@astrojs/language-server/bin/nodeServer.js", "--stdio" },
  --   root_dir = util.root_pattern("package.json"),
  -- })
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = "astro",
    callback = function()
      local root_dir = require("utils").get_root_dir({ "package.json", "tsconfig.json", "jsconfig.json", ".git" })
      vim.lsp.start({
        name = "astro",
        cmd = { "node", nodeModulesPath.."/@astrojs/language-server/bin/nodeServer.js", "--stdio" },
        capabilities = default_capabilities,
        root_dir = root_dir,
      })
    end,
  })

  -- lspconfig.omnisharp.setup({
  --   capabilities = default_capabilities,
  --   cmd = { "E:\\Programs\\OmniSharp\\OmniSharp.exe", "--languageserver", "--hostPID", tostring(pid) },
  -- })
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = {"cs", "vb"},
    callback = function()
      local root_dir = require("utils").get_root_dir({ "*.sln", "*.csproj" })
      vim.lsp.start({
        name = "omnisharp",
        cmd = { "E:\\Programs\\OmniSharp\\OmniSharp.exe", "--languageserver", "--hostPID", tostring(pid) },
        capabilities = default_capabilities,
        root_dir = root_dir,
      })
    end,
  })

  -- lspconfig.sumneko_lua.setup({
  --   capabilities = default_capabilities,
  --   cmd = { "E:\\Programs\\LuaLanguageServer\\bin\\lua-language-server.exe" },
  --   settings = {
  --     Lua = {
  --       runtime = {
  --         version = "LuaJIT",
  --       },
  --       diagnostics = {
  --         globals = { "vim" },
  --       },
  --       workspace = {
  --         library = vim.api.nvim_get_runtime_file("", true),
  --         maxPreload = 2000,
  --         preloadFileSize = 1000
  --       },
  --       telemetry = {
  --         enabled = false,
  --       },
  --     },
  --   },
  -- })
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = "lua",
    callback = function()
      local root_dir = require("utils").get_root_dir({ ".luarc.json", ".luacheckrc", "stylua.toml", ".git" })
      vim.lsp.start({
        name = "lua",
        cmd = { "E:\\Programs\\LuaLanguageServer\\bin\\lua-language-server.exe" },
        capabilities = default_capabilities,
        root_dir = root_dir,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT", },
            diagnostics = { globals = { "vim" }, },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              maxPreload = 2000,
              preloadFileSize = 1000
            },
            telemetry = { enabled = false, },
          },
        }
      })
    end,
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
