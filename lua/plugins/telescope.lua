local function load(use)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('utils').map_key('n', '<leader>nf', ':Telescope find_files<CR>')
      require('utils').map_key('n', '<leader>ng', ':Telescope git_files<CR>')
    end
  }
end

return {
  load = load
}
