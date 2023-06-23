local function configure()
  require("modicator").setup({
    highlights = {
      defaults = { bold = true },
    }
  })
end

return {
  config = configure
}
