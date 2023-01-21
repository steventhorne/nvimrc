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
  vim.cmd([[ set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]])

  vim.cmd([[
    augroup folds
      autocmd!
      autocmd BufRead * normal zR
      autocmd InsertEnter * let w:oldfm = &l:foldmethod | setlocal foldmethod=manual
      autocmd InsertLeave *
        \ if exists('w:oldfm') |
        \   let &l:foldmethod = w:oldfm |
        \   unlet w:oldfm |
        \ endif |
        \ normal! zv
    augroup END
  ]])
end

return {
  config = configure
}
