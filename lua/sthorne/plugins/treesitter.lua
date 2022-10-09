local function configure()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "astro",
      "c_sharp",
      "html",
      "javascript",
      "lua",
      "markdown",
      "rust",
      "svelte",
      "typescript",
    },
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
  })

  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
end

return {
  config = configure
}
