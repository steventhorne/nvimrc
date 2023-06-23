local function draw_label(tabnr)
  local bufnr = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabnr))
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local text = (bufname ~= "") and vim.fn.fnamemodify(bufname, ":t")
    or "[Untitled]"
  return text
end

local function draw()
  local s = ""
  local tab_pages = vim.api.nvim_list_tabpages()
  local selected_tabnr = vim.api.nvim_get_current_tabpage()
  -- loop through tab_pages
  for tabi, tabnr in ipairs(tab_pages) do
    if tabi == selected_tabnr then
      s = s .. "%#TabLineSelAccent# %#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    s = s .. "%" .. tabnr .. "T"

    s = s .. "   "
    if tabi ~= selected_tabnr then
      s = s .. " "
    end
    s = s .. draw_label(tabnr) .. "    "
  end

  s = s .. "%#TabLineFill#"
  return s
end

local function setup()
  local tabline = [[%{%v:lua.require("sthorne.plugins.tabline").draw()%}]]
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

return {
  draw = draw,
  setup = setup,
}
