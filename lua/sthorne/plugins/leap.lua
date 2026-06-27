return {
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set({"n", "x", "o"}, "s", "<Plug>(leap)")
      vim.keymap.set({"n", "x", "o"}, "S", "<Plug>(leap-from-window)")
      vim.keymap.set({"n", "o"}, "gs", function ()
        require("leap.remote").action({
          input = vim.fn.mode(true):match("o") and "" or "v"
        })
      end)
    end
  },
}
