local function configure()
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


  local default_capabilities = require("cmp_nvim_lsp").default_capabilities({
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  })

  default_capabilities = vim.tbl_deep_extend("force", default_capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  })

  local pid = vim.fn.getpid()
  local configPath = vim.fn.stdpath("config")
  local nodeModulesPath = configPath.."/node_modules"
  local masonPackages = vim.fn.stdpath("data").."/mason/packages"

  local au_lsp = vim.api.nvim_create_augroup("LSP", { clear = true })

  local angularNodeModulesPath = masonPackages.."/angular-language-server/node_modules"
  local angularlsCmd = {
    "node",
    angularNodeModulesPath.."/@angular/language-server/index.js",
    "--stdio",
    "--tsProbeLocations",
    angularNodeModulesPath,
    "--ngProbeLocations",
    angularNodeModulesPath.."/@angular/language-server/node_modules",
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
    callback = function(au_args)
      local utils = require("sthorne.utils")
      utils.map_key_buf(au_args.buf, "n", "<LEADER>lf", ":Format")

      if vim.fn.expand("%:e") == ".cshtml" then
        return
      end
      local root_dir = utils.get_root_dir({ "angular.json" })
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
  local tsserver_cmd = {
    "node",
    masonPackages.."/typescript-language-server/node_modules/typescript-language-server/lib/cli.mjs",
    "--stdio"
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = tsserver_filetypes,
    callback = function(au_args)
      local utils = require("sthorne.utils")
      utils.map_key_buf(au_args.buf, "n", "<LEADER>lf", ":Format")

      local root_dir = utils.get_root_dir({ "tsconfig.json", "package.json", "jsconfig.json" })
      local start_config = {
        name = "tsserver",
        capabilities = default_capabilities,
        init_options = {
          hostInfo = "neovim",
          preferences = {
            importModuleSpecifierPreference = "relative",
          },
        },
        cmd = tsserver_cmd,
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

  local eslint_cmd = {
    "node",
    masonPackages.."/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server",
    "--stdio",
  }
  require("lspconfig").eslint.setup({
    cmd = eslint_cmd,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro", "html" },
    on_attach = function(client, bufnr)
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   buffer = bufnr,
      --   command = "EslintFixAll",
      -- })
    end,
  })

  local html_filetypes = {
    "html",
  }
  local html_cmd = {
    "node",
    masonPackages.."/html-lsp/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server",
    "--stdio",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = html_filetypes,
    callback = function(au_args)
      local utils = require("sthorne.utils")
      utils.map_key_buf(au_args.buf, "n", "<LEADER>lf", ":Format")

      local root_dir = utils.get_root_dir({ "package.json", ".git" }, true)
      vim.lsp.start({
        name = "html",
        capabilities = default_capabilities,
        cmd = html_cmd,
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
  local css_cmd = {
    "node",
    masonPackages.."/css-lsp/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server",
    "--stdio",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = css_filetypes,
    callback = function(au_args)
      local utils = require("sthorne.utils")
      utils.map_key_buf(au_args.buf, "n", "<LEADER>lf", ":Format")

      local root_dir = utils.get_root_dir({ "package.json", ".git" }, true)
      vim.lsp.start({
        name = "css",
        capabilities = default_capabilities,
        cmd = css_cmd,
        filetypes = css_filetypes,
        root_dir = root_dir,
      })
    end,
  })

  local svelte_filetypes = {
    "svelte",
  }
  local svelte_cmd = {
    "node",
    masonPackages.."/svelte-language-server/node_modules/svelte-language-server/bin/server.js",
    "--stdio",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = svelte_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "package.json", ".git" })
      vim.lsp.start({
        name = "svelte",
        capabilities = default_capabilities,
        cmd = svelte_cmd,
        filetypes = svelte_filetypes,
        root_dir = root_dir,
      })
    end,
  })

  local astro_filetypes = {
    "astro",
  }
  local astro_cmd = {
    "node",
    masonPackages.."/astro-language-server/node_modules/@astrojs/language-server/bin/nodeServer.js",
    "--stdio",
  }
  local astro_init = {
    typescript = {
      tsdk = masonPackages.."/astro-language-server/node_modules/typescript/lib",
    },
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = astro_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "package.json", "tsconfig.json", "jsconfig.json", ".git" })
      vim.lsp.start({
        name = "astro",
        capabilities = default_capabilities,
        cmd = astro_cmd,
        filetypes = astro_filetypes,
        root_dir = root_dir,
        init_options = astro_init,
      })
    end,
  })

  local omnisharp_cmd = {
    masonPackages.."/omnisharp/omnisharp.cmd",
  }
  require("lspconfig").omnisharp.setup({
    cmd = omnisharp_cmd,
    capabilities = default_capabilities,
    root_dir = function (_, _)
      return require("sthorne.utils").get_root_dir({ "*.sln", "*.csproj" })
    end,
    on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<LEADER>ld", ":lua require('omnisharp_extended').lsp_definitions()<CR>", { noremap = true, silent = true })

      local function to_snake_case(str)
        return string.gsub(str, "%s*[- ]%s*", "_")
      end
      -- fix tokenModifiers and tokenTypes that don't conform to LSP semantic tokens spec
      -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
      local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
      for i, v in ipairs(tokenModifiers) do
        tokenModifiers[i] = to_snake_case(v)
      end
      local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
      for i, v in ipairs(tokenTypes) do
        tokenTypes[i] = to_snake_case(v)
      end
      client.server_capabilities.semanticTokensProvider = {
        full = vim.empty_dict(),
        legend = {
          tokenModifiers = tokenModifiers,
          tokenTypes = tokenTypes,
        },
        range = true,
      }
    end
  })

  -- TODO: Move lua-language-server.exe to config path and use vim.fn.has('win32') to determine which exe to use
  local lua_filetypes = {
    "lua",
  }
  local lua_cmd = {
    masonPackages.."/lua-language-server/extension/server/bin/lua-language-server.exe"
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = lua_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ ".luarc.json", ".luacheckrc", "stylua.toml", ".git" })
      vim.lsp.start({
        name = "lua",
        capabilities = default_capabilities,
        cmd = lua_cmd,
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
              preloadFileSize = 1000,
              checkThirdParty = false,
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
  map_key("n", "<F2>", "<CMD>lua vim.lsp.buf.rename()<CR>")
  map_key("n", "<LEADER>ls", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
  map_key("n", "<LEADER>lf", "<CMD>lua vim.lsp.buf.format()<CR>")
  map_key("n", "<LEADER>la", "<CMD>lua vim.lsp.buf.code_action()<CR>")

  map_key("n", "<LEADER>dh", "<CMD>lua vim.diagnostic.open_float()<CR>")
  map_key("n", "<LEADER>dj", "<CMD>lua vim.diagnostic.goto_next()<CR>")
  map_key("n", "<LEADER>dk", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
  map_key("n", "<LEADER>dJ", "<CMD>lua vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.ERROR } })<CR>")
  map_key("n", "<LEADER>dK", "<CMD>lua vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.ERROR } })<CR>")
end

return {
  config = configure
}
