
local function setup()
  local tabline = [[%{%v:lua.require("sthorne.utils.tabline").draw()%}]]
  local au_tabline = vim.api.nvim_create_augroup("set_tabline", { clear = true })
  vim.api.nvim_create_autocmd("UIEnter", {
    group = au_tabline,
    pattern = "*",
    callback = function()
      if #vim.api.nvim_list_tabpages() > 1 then
        vim.api.nvim_set_option("tabline", tabline)
      end
    end
  })

  vim.api.nvim_create_autocmd("TabNew", {
    group = au_tabline,
    pattern = "*",
    callback = function()
      vim.api.nvim_set_option("tabline", tabline)
    end
  })
end

setup()
