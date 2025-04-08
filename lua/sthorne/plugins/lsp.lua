return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "simrat39/rust-tools.nvim" },
      { "folke/neodev.nvim" },
    },
    config = function()
      -- log level
      -- vim.lsp.set_log_level("debug")

      local default_capabilities = require("cmp_nvim_lsp").default_capabilities({
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
            },
          },
        },
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      })

      local masonPackages = vim.fn.stdpath("data").."/mason/packages"

      local au_lsp = vim.api.nvim_create_augroup("Lsp", { clear = true })
      local au_format_on_save = vim.api.nvim_create_augroup("LspFormatting", {})

      -- local format_on_save = function(client, bufnr, use_lsp)
      --   if client.supports_method("textDocument/formatting") then
      --     vim.api.nvim_clear_autocmds({ group = au_format_on_save, buffer = bufnr })
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       group = au_format_on_save,
      --       buffer = bufnr,
      --       callback = function()
      --         if use_lsp then
      --           vim.lsp.buf.format()
      --         else
      --           vim.cmd("Format")
      --         end
      --       end
      --     })
      --   end
      -- end

      local angularNodeModulesPath = masonPackages.."/angular-language-server/node_modules"
      local angularlsCmd = {
        require("sthorne.utils").get_mason_cmd("ngserver"),
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

      require("lspconfig").ts_ls.setup({
        cmd = {
          require("sthorne.utils").get_mason_cmd("typescript-language-server"),
          "--stdio"
        },
        capabilities = default_capabilities,
        on_attach = function(client, bufnr)
          if vim.b.angularls_enabled then
            vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = bufnr, silent = true })
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.renameProvider = false
          end
        end,
      })

      require("lspconfig").html.setup({
        cmd = {
          require("sthorne.utils").get_mason_cmd("vscode-html-language-server"),
          "--stdio",
        },
        capabilities = default_capabilities,
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = bufnr, silent = true })
        end
      })

      require("lspconfig").cssls.setup({
        cmd = {
          require("sthorne.utils").get_mason_cmd("vscode-css-language-server"),
          "--stdio",
        },
        capabilities = default_capabilities,
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = bufnr, silent = true })
        end
      })

      require("lspconfig").svelte.setup({
        cmd = {
          require("sthorne.utils").get_mason_cmd("svelteserver"),
          "--stdio",
        },
        capabilities = default_capabilities,
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = bufnr, silent = true })
        end
      })

      require("lspconfig").astro.setup({
        cmd = {
          require("sthorne.utils").get_mason_cmd("astro-ls"),
          "--stdio",
        },
        capabilities = default_capabilities,
        init_options = {
          typescript = {
            tsdk = masonPackages.."/astro-language-server/node_modules/typescript/lib",
          },
        },
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = bufnr, silent = true })
        end
      })

      require("lspconfig").omnisharp.setup({
        cmd = {
          require("sthorne.utils").get_mason_cmd("omnisharp"),
        },
        root_dir = function(_, _)
          return require("sthorne.utils").get_root_dir({ "*.sln" })
        end,
        capabilities = default_capabilities,
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

      require("neodev").setup({})

      require('lspconfig').lua_ls.setup({})

      require("lspconfig").gopls.setup({
        cmd = {
          require("sthorne.utils").get_mason_cmd("gopls"),
        },
        capabilities = default_capabilities,
        settings = {
          gopls = {
            staticcheck = true,
          },
        },
        root_dir = require("lspconfig.util").root_pattern({ "go.work", "go.mod", ".git" }),
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = au_format_on_save, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = au_format_on_save,
              buffer = bufnr,
              callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = {only = {"source.organizeImports"}}
                local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
                for cid, res in pairs(result or {}) do
                  for _, r in pairs(res.result or {}) do
                    if r.edit then
                      local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                      vim.lsp.util.apply_workspace_edit(r.edit, enc)
                    end
                  end
                end
                vim.lsp.buf.format({async = false})
              end
            })
          end
        end
      })

      vim.diagnostic.config({
        virtual_lines= {
          current_line = false,
          format = function (diagnostic)
            if diagnostic.severity ~= vim.diagnostic.severity.ERROR then
              return nil
            end
            return diagnostic.message
          end,
        },
        severity_sort=true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "DiagnosticHintLine",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      vim.keymap.set("n", "<LEADER>ld", ":Telescope lsp_definitions<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>lr", ":Telescope lsp_references<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>li", ":Telescope lsp_implementations<CR>", { silent = true })
      vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { silent = true })
      vim.keymap.set("n", "<LEADER>ls", vim.lsp.buf.signature_help, { silent = true })
      vim.keymap.set("n", "<LEADER>lf", vim.lsp.buf.format, { silent = true })
      vim.keymap.set("n", "<LEADER>la", vim.lsp.buf.code_action, { silent = true })

      vim.keymap.set("n", "<LEADER>dh", vim.diagnostic.open_float, { silent = true })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true })
      vim.keymap.set("n", "]D", function() vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.ERROR } }) end, { silent = true })
      vim.keymap.set("n", "[D", function() vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.ERROR } }) end, { silent = true })
    end,
  },
}
