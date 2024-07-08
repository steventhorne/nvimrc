return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("hardtime").setup()
      vim.api.nvim_set_keymap("n", "<leader>ht", "<cmd>lua require('hardtime').toggle()<cr>", { noremap = true, silent = true })
    end,
  },
}
