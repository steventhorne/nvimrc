return {
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_mappings()
      vim.keymap.set({"n", "x", "o"}, "gs", function ()
        require("leap.remote").action()
      end)
    end
  },
}
