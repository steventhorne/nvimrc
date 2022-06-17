local function load(use)
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      local actions = require("telescope.actions")
      local actions_set = require("telescope.actions.set")
      local attach_mappings = function(_)
        actions_set.select:enhance({
          post = function()
            vim.cmd(":normal! zx")
            vim.cmd(":normal! zR")
          end,
        })
        return true
      end

      local default_picker_opts = {
        attach_mappings = attach_mappings,
        prompt_title = "",
        results_title = "",
        preview_title = "",
      }

      require("telescope").setup({
        defaults = {
          layout_config = {
            width = 0.9,
            preview_width = 0.4,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          }
        },
        pickers = {
          buffers = {
            attach_mappings = function(_, map)
              attach_mappings(_)
              map("n", "d", actions.delete_buffer)
              return true
            end,
            prompt_title = "",
            results_title = "",
            preview_title = "",
          },
          find_files = default_picker_opts,
          git_files = default_picker_opts,
          grep_string = default_picker_opts,
          live_grep = default_picker_opts,
          oldfiles = default_picker_opts,
        }
      })

      require("telescope").load_extension("ui-select")

      require("utils").map_key('', "<LEADER>nf", ":Telescope find_files<CR>")
      require("utils").map_key('', "<LEADER>ng", ":Telescope git_files<CR>")
      require("utils").map_key('', "<LEADER>ns", ":Telescope git_status<CR>")
      require("utils").map_key('', "<LEADER>nt", ":Telescope treesitter<CR>")
      require("utils").map_key('', "<LEADER>nb", ":Telescope buffers<CR>")
    end
  })

  use({
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").load_extension("ui-select")
    end
  })
end

return {
  load = load
}

