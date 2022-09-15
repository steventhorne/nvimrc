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
  local angularls_filetypes = {
    "typescript",
    "html",
    "typescriptreact",
    "typescript.tsx",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = angularls_filetypes,
    callback = function()
      if vim.fn.expand("%:e") == ".cshtml" then
        return
      end
      local root_dir = require("sthorne.utils").get_root_dir({ "angular.json" })
      if root_dir ~= nil then
        vim.b.angularls_enabled = true
        vim.lsp.start({
          name = "angularls",
          capabilities = default_capabilities,
          cmd = angularlsCmd,
          filetypes = angularls_filetypes,
          root_dir = root_dir,
          on_new_config = function(new_config)
            new_config.cmd = angularlsCmd
          end,
        })
      end
    end,
  })

  local tsserver_filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = tsserver_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "tsconfig.json", "package.json", "jsconfig.json" })
      local start_config = {
        name = "tsserver",
        capabilities = default_capabilities,
        init_options = { hostInfo = "neovim" },
        cmd = { "node", nodeModulesPath.."/typescript-language-server/lib/cli.js", "--stdio" },
        filetypes = tsserver_filetypes,
        root_dir = root_dir,
      }
      if vim.b.angularls_enabled then
        start_config.on_attach = function(client, _)
          client.server_capabilities.referencesProvider = false
          client.server_capabilities.renameProvider = false
        end
      end
      vim.lsp.start(start_config)
    end,
  })

  local html_filetypes = {
    "html",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = html_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "package.json", ".git" }, true)
      vim.lsp.start({
        name = "html",
        capabilities = default_capabilities,
        cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-html-language-server", "--stdio" },
        filetypes = html_filetypes,
        root_dir = root_dir,
      })
    end,
  })

  local css_filetypes = {
    "css",
    "less",
    "scss",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = css_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "package.json", ".git" }, true)
      vim.lsp.start({
        name = "css",
        capabilities = default_capabilities,
        cmd = { "node", nodeModulesPath.."/vscode-langservers-extracted/bin/vscode-css-language-server", "--stdio" },
        filetypes = css_filetypes,
        root_dir = root_dir,
      })
    end,
  })

  local svelte_filetypes = {
    "svelte",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = svelte_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "package.json", ".git" })
      vim.lsp.start({
        name = "svelte",
        capabilities = default_capabilities,
        cmd = { "node", nodeModulesPath.."/svelte-language-server/bin/server.js", "--stdio" },
        filetypes = svelte_filetypes,
        root_dir = root_dir,
      })
    end,
  })

  local astro_filetypes = {
    "astro",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = astro_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "package.json", "tsconfig.json", "jsconfig.json", ".git" })
      vim.lsp.start({
        name = "astro",
        capabilities = default_capabilities,
        cmd = { "node", nodeModulesPath.."/@astrojs/language-server/bin/nodeServer.js", "--stdio" },
        filetypes = astro_filetypes,
        root_dir = root_dir,
      })
    end,
  })

  -- TODO: Move OmniSharp.exe to config path and use vim.fn.has('win32') to determine which exe to use
  local omnisharp_filetypes = {
    "cs",
    "vb",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = omnisharp_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "*.sln", "*.csproj" })
      vim.lsp.start({
        name = "omnisharp",
        capabilities = default_capabilities,
        cmd = { "E:\\Programs\\OmniSharp\\OmniSharp.exe", "--languageserver", "--hostPID", tostring(pid) },
        filetypes = omnisharp_filetypes,
        root_dir = root_dir,
        enable_editorconfig_support = true,
        enable_ms_build_load_projects_on_demand = false,
        enable_roslyn_analyzers = false,
        organize_imports_on_format = false,
        enable_import_completion = false,
        sdk_include_prereleases = true,
        analyze_open_documents_only = false,
        on_new_config = function(new_config, new_root_dir)
          table.insert(new_config.cmd, '-z') -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
          vim.list_extend(new_config.cmd, { '-s', new_root_dir })
          vim.list_extend(new_config.cmd, { '--hostPID', tostring(vim.fn.getpid()) })
          table.insert(new_config.cmd, 'DotNet:enablePackageRestore=false')
          vim.list_extend(new_config.cmd, { '--encoding', 'utf-8' })
          table.insert(new_config.cmd, '--languageserver')

          if new_config.enable_editorconfig_support then
            table.insert(new_config.cmd, 'FormattingOptions:EnableEditorConfigSupport=true')
          end

          if new_config.organize_imports_on_format then
            table.insert(new_config.cmd, 'FormattingOptions:OrganizeImports=true')
          end

          if new_config.enable_ms_build_load_projects_on_demand then
            table.insert(new_config.cmd, 'MsBuild:LoadProjectsOnDemand=true')
          end

          if new_config.enable_roslyn_analyzers then
            table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableAnalyzersSupport=true')
          end

          if new_config.enable_import_completion then
            table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableImportCompletion=true')
          end

          if new_config.sdk_include_prereleases then
            table.insert(new_config.cmd, 'Sdk:IncludePrereleases=true')
          end

          if new_config.analyze_open_documents_only then
            table.insert(new_config.cmd, 'RoslynExtensionsOptions:AnalyzeOpenDocumentsOnly=true')
          end
        end,
      })
    end,
  })

  local lua_filetypes = {
    "lua",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = lua_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ ".luarc.json", ".luacheckrc", "stylua.toml", ".git" })
      vim.lsp.start({
        name = "lua",
        capabilities = default_capabilities,
        cmd = { "E:\\Programs\\LuaLanguageServer\\bin\\lua-language-server.exe" },
        filetypes = lua_filetypes,
        root_dir = root_dir,
        single_file_support = true,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
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

  local map_key = require("sthorne.utils").map_key
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
