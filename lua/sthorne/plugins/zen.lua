return {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup({
      window = {
        width = .7,
      }
    })
    vim.keymap.set("n", "<LEADER>ff", ":ZenMode<CR>", { silent = true })
  end
}
