local function load(use)
  use({
    "preservim/nerdtree",
    config = function()
      vim.cmd([[ let g:NERDTreeWinPos = "right" ]])
      vim.cmd([[ let g:NERDTreeWinSize = 35 ]])
      vim.cmd([[ let NERDTreeShowHidden = 0 ]])
      vim.cmd([[ let NERDTreeStatusline = -1 ]])
      vim.cmd([[ let NERDTreeDirArrowExpandable = " " ]])
      vim.cmd([[ let NERDTreeDirArrowCollapsible = " " ]])
      require("utils").map_key("n", "<LEADER>nn", ":NERDTreeToggle<CR>")
    end
  })
end

return {
  load = load
}

