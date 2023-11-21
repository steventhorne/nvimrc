local function configure()
  require("modicator").setup({
    show_warnings = false,
    highlights = {
      defaults = { bold = true },
    }
  })
end

return {
  config = configure
}
