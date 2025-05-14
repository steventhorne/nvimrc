return {
  cmd = {
    require("sthorne.utils").get_mason_cmd("vscode-css-language-server"),
    "--stdio",
  }
}
