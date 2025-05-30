return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/playground" },
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "astro",
          "c_sharp",
          "comment",
          "css",
          "go",
          "html",
          "javascript",
          "jsdoc",
          "lua",
          "markdown",
          "svelte",
          "typescript",
          "vimdoc",
        },
        sync_install = false,
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
      })

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
      vim.opt.foldlevelstart = 99
    end,
  },
}
