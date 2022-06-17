local function load(use)
  use({
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end
  })
end

return {
  load = load
}

