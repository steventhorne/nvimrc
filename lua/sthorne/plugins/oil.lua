local function configure()
  require("oil").setup({
    columns = { "icon" },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-x>"] = "actions.select_split",
      ["<C-s>"] = false,
      ["<C-v>"] = "actions.select_vsplit",
    },
    view_options = {
      show_hidden = true,
    },
  })

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  vim.keymap.set("n", "<LEADER>-", require("oil").toggle_float)
end

return {
  config = configure
}
