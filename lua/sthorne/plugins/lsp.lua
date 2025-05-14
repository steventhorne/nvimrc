return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "simrat39/rust-tools.nvim" },
      { "folke/neodev.nvim" },
    },
    config = function()
      vim.lsp.set_log_level("debug")

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

      vim.lsp.config("*", {
        capabilities = default_capabilities
      })

      local masonPackages = vim.fn.stdpath("data").."/mason/packages"

      local au_lsp = vim.api.nvim_create_augroup("Lsp", { clear = true })

      -- angular is handled in a special case to deal with ts_ls conflicts
      local angularNodeModulesPath = masonPackages.."/angular-language-server/node_modules"
      local angularlsCmd = {
        "ngserver",
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
        "htmlangular",
      }
      vim.api.nvim_create_autocmd("FileType", {
        group = au_lsp,
        pattern = angularls_filetypes,
        callback = function()
          local utils = require("sthorne.utils")

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

      ---@diagnostic disable-next-line: missing-fields
      require("neodev").setup({})
      require("lspconfig").lua_ls.setup({})

      vim.lsp.enable("ts_ls")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("svelte")
      -- disabled due to conflicts with other project types
      -- enable manually in an astro project
      -- vim.lsp.enable("astro")
      vim.lsp.enable("omnisharp")
      vim.lsp.enable("gopls")

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

      vim.keymap.set("n", "K", function() vim.lsp.buf.hover({border="rounded"}) end, { silent = true })
      vim.keymap.set("n", "<LEADER>ld", ":Telescope lsp_definitions<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>lr", ":Telescope lsp_references<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>li", ":Telescope lsp_implementations<CR>", { silent = true })
      vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { silent = true })
      vim.keymap.set("n", "<LEADER>ls", vim.lsp.buf.signature_help, { silent = true })
      vim.keymap.set("n", "<LEADER>lf", vim.lsp.buf.format, { silent = true })
      vim.keymap.set("n", "<LEADER>la", vim.lsp.buf.code_action, { silent = true })

      vim.keymap.set("n", "<LEADER>dh", vim.diagnostic.open_float, { silent = true })
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count=1, float=true }) end, { silent = true })
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count=-1, float=true }) end, { silent = true })
      vim.keymap.set("n", "]D", function() vim.diagnostic.jump({ count=1, float=true, severity = { min = vim.diagnostic.severity.ERROR } }) end, { silent = true })
      vim.keymap.set("n", "[D", function() vim.diagnostic.jump({ count=-1, float=true, severity = { min = vim.diagnostic.severity.ERROR } }) end, { silent = true })
    end,
  },
}
