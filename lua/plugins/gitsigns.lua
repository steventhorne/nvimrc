local function load(use)
  use({
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end
  })
end

return {
  load = load
}

