return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<LEADER>gs", ":Git<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>gb", ":Git blame<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>gd", ":Ghdiffsplit<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>gl", ":Git log<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>gf", ":Git fetch<CR>", { silent = true })
      vim.keymap.set("n", "<LEADER>gp", ":Git pull --autostash<CR>", { silent = true })
    end,
  },
}
