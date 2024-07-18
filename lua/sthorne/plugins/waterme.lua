return {
  "steventhorne/nvim-waterme",
  dependencies = {
    { "rcarriga/nvim-notify" },
  },
  config = function()
    require("waterme").setup()
  end
}
