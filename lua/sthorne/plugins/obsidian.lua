return {
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "windows",
          path = "~/Documents/obsidian",
        }
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      }
    })
  end
}
