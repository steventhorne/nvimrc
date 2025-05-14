return {
  cmd = {
    require("sthorne.utils").get_mason_cmd("vscode-html-language-server"),
    "--stdio",
  },
  on_attach = function(_, bufnr)
    vim.keymap.set("n", "<LEADER>lf", ":Format", { buffer = bufnr, silent = true })
  end
}
