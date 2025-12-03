return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      { "jay-babu/mason-nvim-dap.nvim" },
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      require("mason").setup({
        registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
      })
      require("mason-lspconfig").setup()
      require("mason-nvim-dap").setup()
    end,
  },
}
