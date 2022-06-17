local function load(use)
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "typescript", "javascript", "html", "rust", "c_sharp" },
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
  })
end

return {
  load = load,
}

