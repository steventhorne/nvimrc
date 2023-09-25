local function configure()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "astro",
      "comment",
      "c_sharp",
      "go",
      "html",
      "javascript",
      "lua",
      "markdown",
      "rust",
      "svelte",
      "typescript",
    },
    sync_install = false,
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
  })

  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.tintin = {
    install_info = {
      url = "https://github.com/steventhorne/tree-sitter-tintin.git",
      files = { "src/parser.c" },
    },
  }

  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldenable = false
  vim.opt.foldlevelstart = 99
end

return {
  config = configure
}
