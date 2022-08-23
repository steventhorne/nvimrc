local function configure()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "c",
      "lua",
      "typescript",
      "javascript",
      "html",
      "rust",
      "c_sharp",
      "svelte",
      "astro",
    },
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
  })

  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

  vim.cmd([[
    autocmd BufRead * normal zR
  ]])
end

return {
  config = configure
}
