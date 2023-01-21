local configure = function()
  local prettier = require("formatter.defaults.prettier")
  local util = require("formatter.util")
  require("formatter").setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      css = require("formatter.filetypes.css").prettier,
      html = require("formatter.filetypes.html").prettier,
      javascript = require("formatter.filetypes.javascript").prettier,
      javascriptreact = require("formatter.filetypes.javascriptreact").prettier,
      less = util.withl(prettier, "less"),
      lua = require("formatter.filetypes.lua").stylua,
      svelte = require("formatter.filetypes.svelte").prettier,
      typescript = require("formatter.filetypes.typescript").prettier,
      typescriptreact = require("formatter.filetypes.typescriptreact").prettier,
      ["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace,
      }
    }
  })

  local map_key = require("sthorne.utils").map_key
  map_key("n", "<LEADER>f", ":Format<CR>")
end

return {
  config = configure,
}
