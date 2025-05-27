return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "echasnovski/mini.icons", opts = {} },
    },
    config = function()
      require("oil").setup({
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-x>"] = "actions.select_split",
          ["<C-s>"] = false,
          ["<C-v>"] = "actions.select_vsplit",
          ["q"] = { "actions.close", mode = "n" },
          ["<C-c>"] = false,
          ["<C-l>"] = false,
        },
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<LEADER>-", require("oil").toggle_float, { desc = "Open parent directory in float" })
    end,
  },
}
