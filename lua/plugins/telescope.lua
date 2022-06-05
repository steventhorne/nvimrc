local function load(use)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('utils').map_key('n', '<leader>nf', ':Telescope find_files<CR>')
    end
  }
end

return {
  load = load
}
