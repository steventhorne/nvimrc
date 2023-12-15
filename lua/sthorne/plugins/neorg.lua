local function configure()
  require("neorg").setup({
    load = {
      ["core.defaults"] = {},
      ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
      ["core.integrations.nvim-cmp"] = {},
      ["core.concealer"] = { config = { icon_preset = "diamond" } },
      ["core.export"] = {},
      ["core.export.markdown"] = {},
      ["core.keybinds"] = {
        config = {
          default_keybinds = true,
          neorg_leader = "<Leader><Leader>",
        },
      },
      ["core.esupports.metagen"] = {
        config = {
          tab = "  ",
          type = "auto",
          update_date = true,
        }
      },
      ["core.qol.toc"] = {},
      ["core.qol.todo_items"] = {},
      ["core.looking-glass"] = {},
    },
  })

  local au_norg = vim.api.nvim_create_augroup("Norg", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = au_norg,
    callback = function()
      vim.cmd("silent! Neorg update-metadata")
    end,
  })
end

return {
  config = configure
}
