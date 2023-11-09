local function configure()
  local starter = require("mini.starter")
  starter.setup({
    items = {
      starter.sections.sessions(15, false),
    },
    header = "",
    footer = "",
    directory = vim.fn.stdpath("data") .. "/sessions/"
  })
end

return {
  config = configure
}
