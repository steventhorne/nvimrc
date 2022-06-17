local function load(use)
  use({
    "tomasiser/vim-code-dark",
    config = function() vim.cmd([[ colorscheme codedark ]]) end
  })
end

return {
  load = load
}

