local function load(use)
  use {
    'preservim/nerdtree',
    config = function()
      vim.cmd([[ let g:NERDTreeWinPos = 'right' ]])
      vim.cmd([[ let g:NERDTreeWinSize = 35 ]])
      vim.cmd([[ let NERDTreeShowHidden = 0 ]])
      require('utils').map_key('n', '<leader>nn', ':NERDTreeToggle<CR>')
    end
  }
end

return {
  load = load
}
