return {
  cmd = {
    require("sthorne.utils").get_mason_cmd("vscode-html-language-server"),
    "--stdio",
  }
}
