local function configure()
  local custom_fname = require("lualine.components.filename"):extend()
  local highlight = require("lualine.highlight")
  local dap = require("dap")
  local attached = false

  dap.listeners.after["event_initialized"]["me"] = function()
    attached = true
  end

  dap.listeners.after["event_terminated"]["me"] = function()
    attached = false
  end

  vim.api.nvim_set_hl(0, "lualine_c_diagnostics_error_normal", { fg = "#de5d68" })

  function custom_fname:init(options)
    custom_fname.super.init(self, options)
    self.status_colors = {
      modified = {
        name = "lualine_c_diagnostics_error_normal",
        fn = nil,
        no_mode = true,
        link = true,
        section = self.options.self.section,
        options = options,
        no_default = nil
      }
    }
  end

  function custom_fname:update_status()
    local sig = { label = "" }
    -- if pcall(require, "lsp_signature") then
    --   sig = require("lsp_signature").status_line()
    -- end
    local status
    if string.sub(vim.api.nvim_get_mode().mode, 1, 1) == "i" and sig.label ~= "" then
      status = sig.label
    else
      status = custom_fname.super.update_status(self)
      if vim.bo.modified and self.status_colors.modified then
        status = highlight.component_format_highlight(self.status_colors.modified) .. status
      end
    end
    if attached then
      status = status .. " "
    end
    return status
  end

  require("lualine").setup {
    options = {
      icons_enabled = true,
      theme = "onedark",
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {
        'branch',
        'diff',
        'diagnostics',
      },
      lualine_c = {
        {
          custom_fname,
          file_status = true,
          path = 1,
          shorting_target = 40,
          symbols = {
            modified = ' ',
            readonly = ' ',
            unnamed = '[No Name]',
          }
        },
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
