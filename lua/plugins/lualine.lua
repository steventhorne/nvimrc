local function load(use)
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "codedark",
          globalstatus = true,
        },
      }
    end,
  })
end

return {
  load = load
}

