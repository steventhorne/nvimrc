return {
  cmd = {
    require("sthorne.utils").get_mason_cmd("typescript-language-server"),
    "--stdio"
  },
  on_attach = function(client)
    -- This doesn't work anymore because of dynamic registration
    -- Watch this discussion: https://github.com/neovim/neovim/discussions/24058
    if vim.b.angularls_enabled then
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.renameProvider = false
    end
  end,
}
