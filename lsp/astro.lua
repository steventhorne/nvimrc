local masonPackages = vim.fn.stdpath("data").."/mason/packages"

return {
  init_options = {
    typescript = {
      tsdk = masonPackages.."/astro-language-server/node_modules/typescript/lib",
    },
  }
}
