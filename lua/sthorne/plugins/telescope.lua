return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = function(plugin)
          local obj = vim.system({'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release'}, {cwd = plugin.dir}):wait()
          if obj.code ~= 0 then error(obj.stderr) end
          obj = vim.system({'cmake', '--build', 'build', '--config', 'Release'}, {cwd = plugin.dir}):wait()
          if obj.code ~= 0 then error(obj.stderr) end
          obj = vim.system({'cmake', '--install', 'build', '--prefix', 'build'}, {cwd = plugin.dir}):wait()
          if obj.code ~= 0 then error(obj.stderr) end
        end
      },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "mfussenegger/nvim-dap" },
    },
    config = function()
      local actions = require("telescope.actions")
      local add_to_trouble = require("trouble.sources.telescope").add

      require("telescope").setup({
        defaults = {
          preview = {
            filesize_limit = 0.2, -- MB
          },
          results_title = false,
          layout_config = {
            width = 0.9,
          },
          path_display = {
            truncate = 30,
          },
          file_ignore_patterns = {
            "node_modules",
            "%.meta",
          },
          mappings = {
            n = {
              ["q"] = require("telescope.actions").close,
              ["<c-t>"] = add_to_trouble,
            },
            i = {
              ["<esc>"] = require("telescope.actions").close,
              ["<c-t>"] = add_to_trouble,
            }
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              prompt_title = "",
              results_title = "",
              preview_title = "",
            })
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        },
        pickers = {
          buffers = {
            mappings = {
              n = {
                ["d"] = actions.delete_buffer,
              },
            },
            preview_width = 0.4,
            prompt_title = "",
            results_title = "",
            preview_title = "",
          },
          -- find_files = {},
          -- live_grep = {},
          -- git_files = {},
          git_status = {
            preview_width = 0.4,
            git_icons = {
              added = "A",
              changed = "M",
              deleted = "D",
            },
          },
          lsp_document_symbols = {
            preview_width = 0.4,
            show_line = false,
          },
          lsp_definitions = {
            preview_width = 0.4,
            show_line = false,
            reuse_win = true,
          },
          lsp_references = {
            preview_width = 0.4,
            show_line = false,
          },
          lsp_implementations = {
            preview_width = 0.4,
            show_line = false,
            reuse_win = true,
          },
        }
      })

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("flutter")

      vim.keymap.set('', "<LEADER>nf", ":Telescope current_buffer_fuzzy_find<CR>", { silent = true })
      vim.keymap.set('', "<LEADER>nF", ":Telescope live_grep<CR>", { silent = true })
      vim.keymap.set('', "<LEADER>ns", ":Telescope git_status<CR>", { silent = true })
      vim.keymap.set('', "<LEADER>nt", ":Telescope lsp_document_symbols<CR>", { silent = true })
      vim.keymap.set('', "<LEADER>nb", ":Telescope buffers<CR>", { silent = true })
      vim.keymap.set('', "<LEADER>ng", function() require("sthorne.utils.telescope").git_files_with_fallback(false) end, { silent = true })
      vim.keymap.set('', "<LEADER>nG", function() require("sthorne.utils.telescope").git_files_with_fallback(true) end, { silent = true })
      vim.keymap.set('', "<LEADER>nh", ":Telescope help_tags<CR>", { silent = true })
    end,
  },
}
