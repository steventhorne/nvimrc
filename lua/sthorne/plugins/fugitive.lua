return {
  config = function()
    vim.keymap.set("n", "<LEADER>gs", ":Git<CR>")
    vim.keymap.set("n", "<LEADER>gb", ":Git blame<CR>")
    vim.keymap.set("n", "<LEADER>gd", ":Ghdiffsplit<CR>")
    vim.keymap.set("n", "<LEADER>gl", ":Git log<CR>")
  end
}
