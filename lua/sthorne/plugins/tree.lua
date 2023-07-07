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
  })
  require("sthorne.utils").map_key("n", "<LEADER>nn", ":NvimTreeToggle<CR>")
  require("sthorne.utils").map_key("n", "<LEADER>nN", ":NvimTreeFindFile<CR>")
end

return {
  config = configure
}
