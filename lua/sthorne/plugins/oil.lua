local function configure()
  require("oil").setup({
    columns = { "icon" },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-x>"] = "actions.select_split",
      ["<C-s>"] = false,
      ["<C-v>"] = "actions.select_vsplit",
    },
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return name == ".." or name == ".git"
      end,
    },
  })

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  vim.keymap.set("n", "<LEADER>-", require("oil").toggle_float)
end

return {
  config = configure
}
