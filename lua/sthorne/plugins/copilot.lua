return {
  {
    "github/copilot.vim",
    cond = vim.fn.getcwd():find("^"..vim.fn.expand("~/Documents/Writable")),
    config = function()
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
      print("copilot loaded")
    end,
  },
}
