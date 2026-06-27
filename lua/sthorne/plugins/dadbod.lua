return {
  "tpope/vim-dadbod",
  dependencies = {
    { "kristijanhusak/vim-dadbod-ui" },
    { "kristijanhusak/vim-dadbod-completion" },
  },
  lazy = true,
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1
    vim.g.db_ui_bind_param_pattern = "\\$\\[\\w+\\]"

    vim.api.nvim_create_autocmd("User", {
      pattern = "DBUIOpened",
      callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
      end,
    })
  end
}
