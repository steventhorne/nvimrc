local function configure()
  local custom_fname = require("lualine.components.filename"):extend()
  local highlight = require("lualine.highlight")
  local dap = require("dap")
  local attached = false

  local status_colors = { saved = "#6a9955", modified = "#d7ba7d" }

  dap.listeners.after["event_initialized"]["me"] = function()
    attached = true
  end

  dap.listeners.after["event_terminated"]["me"] = function()
    attached = false
  end

  function custom_fname:init(options)
    custom_fname.super.init(self, options)
    self.status_colors = {
      saved = highlight.create_component_highlight_group(
        {bg = status_colors.saved, fg = "#000000"}, "filename_status_saved", self.options),
      modified = highlight.create_component_highlight_group(
        {bg = status_colors.modified, fg = "#000000"}, "filename_status_modified", self.options),
    }
  end

  function custom_fname:update_status()
    if not pcall(require, "lsp_signature") then return end
    local sig = require("lsp_signature").status_line()
    local status
    if sig.label ~= "" then
      status = sig.label
    else
      status = custom_fname.super.update_status(self)
      status = highlight.component_format_highlight(vim.bo.modified and self.status_colors.modified or self.status_colors.saved) .. status
    end
    if attached then
      status = status .. " "
    end
    return status
  end

  require("lualine").setup {
    options = {
      icons_enabled = true,
      theme = "codedark",
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {
        {
          custom_fname,
          file_status = true,
          path = 1,
          shorting_target = 40,
          symbols = {
            modified = ' ',
            readonly = ' ',
            unnamed = '[No Name]',
          }
        }
      },
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    extensions = {
      "nerdtree",
      "fugitive",
      "quickfix",
    },
  }
end

return {
  config = configure
}
