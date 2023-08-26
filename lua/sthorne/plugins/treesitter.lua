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

  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldenable = false
  vim.opt.foldlevelstart = 99
end

return {
  config = configure
}
