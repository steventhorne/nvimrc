local hover
local function toggle_hover()
  if (not hover) then
    local widgets = require("dap.ui.widgets");
    hover = widgets.cursor_float(widgets.expression);
  end
  hover.toggle()
end

return {
  toggle_hover = toggle_hover,
}
