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
    if tabnr == selected_tabnr then
      s = s .. "%#TabLineSelAccent# %#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    s = s .. "%" .. tabnr .. "T"

    s = s .. "   "
    if tabnr ~= selected_tabnr then
      s = s .. " "
    end
    s = s .. draw_label(tabnr) .. "    "
  end

  s = s .. "%#TabLineFill#"
  return s
end

return {
  draw = draw,
}
