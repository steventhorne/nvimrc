local function load(use)
  use {
    'tpope/vim-surround',
    ft = {'html', 'xml'}
  }
end

return {
  load = load
}
