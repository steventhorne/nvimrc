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
  local masonBin = vim.fn.stdpath("data").."/mason/bin"

  local au_lsp = vim.api.nvim_create_augroup("Lsp", { clear = true })
  local au_format_on_save = vim.api.nvim_create_augroup("LspFormatting", {})

  local format_on_save = function(client, bufnr, use_lsp)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = au_format_on_save, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = au_format_on_save,
        buffer = bufnr,
        callback = function()
          if use_lsp then
            vim.lsp.buf.format()
          else
            vim.cmd("Format")
          end
        end
      })
    end
  end

  local angularNodeModulesPath = masonPackages.."/angular-language-server/node_modules"
  local angularlsCmd = {
    masonBin.."/ngserver.cmd",
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
      vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = au_args.buf, silent = true })

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
    masonBin.."/typescript-language-server.cmd",
    "--stdio"
  }
  -- vim.api.nvim_create_autocmd("FileType", {
  --   group = au_lsp,
  --   pattern = tsserver_filetypes,
  --   callback = function(au_args)
  --     local utils = require("sthorne.utils")
  --     vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = au_args.buf, silent = true })
  --
  --     local root_dir = utils.get_root_dir({ "tsconfig.json", "package.json", "jsconfig.json" })
  --     local start_config = {
  --       name = "tsserver3",
  --       capabilities = default_capabilities,
  --       init_options = {
  --         hostInfo = "neovim",
  --         preferences = {
  --           importModuleSpecifierPreference = "relative",
  --         },
  --       },
  --       cmd = tsserver_cmd,
  --       filetypes = tsserver_filetypes,
  --       root_dir = root_dir,
  --       autostart = true,
  --       single_file_support = true,
  --     }
  --     if vim.b.angularls_enabled then
  --       start_config.on_attach = function(client, _)
  --         client.server_capabilities.referencesProvider = false
  --         client.server_capabilities.renameProvider = false
  --       end
  --     end
  --     vim.lsp.start(start_config)
  --   end,
  -- })

  require("lspconfig").tsserver.setup({
    cmd = tsserver_cmd,
    capabilities = default_capabilities,
    on_attach = function(client, bufnr)
      if vim.b.angularls_enabled then
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.renameProvider = false
      end
    end,
  })

  -- local eslint_cmd = {
  --   "node",
  --   masonPackages.."/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server",
  --   "--stdio",
  -- }
  -- require("lspconfig").eslint.setup({
  --   cmd = eslint_cmd,
  --   filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro", "html" },
  --   on_attach = function(client, bufnr)
  --     -- vim.api.nvim_create_autocmd("BufWritePre", {
  --     --   buffer = bufnr,
  --     --   command = "EslintFixAll",
  --     -- })
  --   end,
  -- })
  --
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
      vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = au_args.buf, silent = true })

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
      vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = au_args.buf, silent = true })

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

  local csharp_filetypes = {
    "cs", "vb", "cshtml"
  }
  local csharp_cmd = {
    masonBin.."/omnisharp.cmd",
  }
  require("lspconfig").omnisharp.setup({
    cmd = csharp_cmd,
    filetypes = csharp_filetypes,
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

  require('lspconfig').lua_ls.setup({
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths here.
                -- E.g.: For using `vim.*` functions, add vim.env.VIMRUNTIME/lua.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          }
        })
      end
      return true
    end
  })

  local go_filetypes = {
    "go", "gomod", "gowork", "gotmpl"
  }
  local go_cmd = {
    masonBin.."/gopls.cmd",
  }
  vim.api.nvim_create_autocmd("FileType", {
    group = au_lsp,
    pattern = go_filetypes,
    callback = function()
      local root_dir = require("sthorne.utils").get_root_dir({ "go.work", "go.mod", ".git" })
      vim.lsp.start({
        name = "go",
        capabilities = default_capabilities,
        settings = {
          gopls = {
            staticcheck = true,
          },
        },
        cmd = go_cmd,
        filetypes = go_filetypes,
        root_dir = root_dir,
        single_file_support = true,
        on_attach = function(client, bufnr)
          format_on_save(client, bufnr, true)
        end
      })
    end
  })

  -- require("lspconfig").gopls.setup({
  --   capabilities = default_capabilities,
  --   settings = {
  --     gopls = {
  --       staticcheck = true,
  --     },
  --   },
  --   on_attach = function(client, bufnr)
  --     if client.supports_method("textDocument/formatting") then
  --       vim.api.nvim_clear_autocmds({ group = au_format_on_save, buffer = bufnr })
  --       vim.api.nvim_create_autocmd("BufWritePre", {
  --         group = au_format_on_save,
  --         buffer = bufnr,
  --         callback = function()
  --           local params = vim.lsp.util.make_range_params()
  --           params.context = {only = {"source.organizeImports"}}
  --           local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
  --           for cid, res in pairs(result or {}) do
  --             for _, r in pairs(res.result or {}) do
  --               if r.edit then
  --                 local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
  --                 vim.lsp.util.apply_workspace_edit(r.edit, enc)
  --               end
  --             end
  --           end
  --           vim.lsp.buf.format({async = false})
  --         end
  --       })
  --     end
  --   end
  -- })

  vim.diagnostic.config({ severity_sort=true })

  vim.fn.sign_define("DiagnosticSignError", { text="", texthl="DiagnosticError", linehl="", numhl="" })
  vim.fn.sign_define("DiagnosticSignWarn", { text="", texthl="DiagnosticWarn", linehl="", numhl="" })
  vim.fn.sign_define("DiagnosticSignHint", { text="", texthl="DiagnosticHint", linehl="", numhl="" })
  vim.fn.sign_define("DiagnosticSignInfo", { text="", texthl="DiagnosticInfo", linehl="", numhl="" })

  vim.keymap.set("n", "<LEADER>ld", ":Telescope lsp_definitions<CR>", { silent = true })
  vim.keymap.set("n", "<LEADER>lr", ":Telescope lsp_references<CR>", { silent = true })
  vim.keymap.set("n", "<LEADER>lh", vim.lsp.buf.hover, { silent = true })
  vim.keymap.set("n", "<LEADER>li", ":Telescope lsp_implementations<CR>", { silent = true })
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { silent = true })
  vim.keymap.set("n", "<LEADER>ls", vim.lsp.buf.signature_help, { silent = true })
  vim.keymap.set("n", "<LEADER>lf", vim.lsp.buf.format, { silent = true })
  vim.keymap.set("n", "<LEADER>la", vim.lsp.buf.code_action, { silent = true })

  vim.keymap.set("n", "<LEADER>dh", vim.diagnostic.open_float, { silent = true })
  vim.keymap.set("n", "<LEADER>dj", vim.diagnostic.goto_next, { silent = true })
  vim.keymap.set("n", "<LEADER>dk", vim.diagnostic.goto_prev, { silent = true })
  vim.keymap.set("n", "<LEADER>dJ", function() vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.ERROR } }) end, { silent = true })
  vim.keymap.set("n", "<LEADER>dK", function() vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.ERROR } }) end, { silent = true })
end

return {
  config = configure
}
