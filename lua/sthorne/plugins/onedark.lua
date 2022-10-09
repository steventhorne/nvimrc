return {
  config = function()
    require("onedark").setup({
      style = "warmer",

      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "italic",
        variables = "none",
      },

      lualine = {
        transparent = true,
      },

      diagnostics = {
        darker = false,
        undercurl = true,
        background = true,
      },
    })
    require("onedark").load()
  end
}
