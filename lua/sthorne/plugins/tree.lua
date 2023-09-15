local function configure()
  require("nvim-tree").setup({
    sync_root_with_cwd = true,
    view = {
      width = 30,
      side = "right",
      number = true,
      relativenumber = true,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    git = {
      enable = false,
    },
  })

  vim.keymap.set("n", "<LEADER>nn", ":NvimTreeToggle<CR>", { silent = true })
  vim.keymap.set("n", "<LEADER>nN", ":NvimTreeFindFile<CR>", { silent = true })
end

return {
  config = configure
}
