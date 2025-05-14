local masonPackages = vim.fn.stdpath("data").."/mason/packages"

return {
  cmd = {
    require("sthorne.utils").get_mason_cmd("astro-ls"),
    "--stdio",
  },
  init_options = {
    typescript = {
      tsdk = masonPackages.."/astro-language-server/node_modules/typescript/lib",
    },
  },
  on_attach = function(_, bufnr)
    vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = bufnr, silent = true })
  end
}
