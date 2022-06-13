local function load(use)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local fixfolds = {
        hidden = true,
        attach_mappings = function(_)
          require("telescope.actions.set").select:enhance({
            post = function()
              vim.cmd(":normal! zx")
              vim.cmd(":normal! zR")
            end,
          })
          return true
        end,
      }

      require('telescope').setup{
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
          }
        },
        pickers = {
          buffers = fixfolds,
          find_files = fixfolds,
          git_files = fixfolds,
          grep_string = fixfolds,
          live_grep = fixfolds,
          oldfiles = fixfolds,
        }
      }

      require('telescope').load_extension('ui-select')

      require('utils').map_key('n', '<leader>nf', ':Telescope find_files<CR>')
      require('utils').map_key('n', '<leader>ng', ':Telescope git_files<CR>')
    end
  }

  use {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require('telescope').load_extension('ui-select')
    end
  }
end

return {
  load = load
}
