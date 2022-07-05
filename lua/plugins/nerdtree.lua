local function load(use)
  use({
    "preservim/nerdtree",
    config = function()
      vim.cmd([[ let g:NERDTreeWinPos = "right" ]])
      vim.cmd([[ let NERDTreeStatusline = -1 ]])
      vim.cmd([[ let NERDTreeDirArrowExpandable = " " ]])
      vim.cmd([[ let NERDTreeDirArrowCollapsible = " " ]])
      vim.cmd([[ let NERDTreeMinimalUI = 1 ]])
      vim.cmd([[ let NERDTreeChDirMode = 2 ]])
      vim.cmd([[ let NERDTreeMarkBookmarks = 0 ]])
      vim.cmd([[ let NERDTreeQuitOnOpen = 3 ]])
      vim.cmd([[ let NERDTreeShowBookmarks = 1 ]])
      require("utils").map_key("n", "<LEADER>nn", ":NERDTreeToggle<CR>")
    end
  })
end

return {
  load = load
}

