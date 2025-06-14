return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "mfussenegger/nvim-dap" },
    },
    config = function()
      local custom_fname = require("lualine.components.filename"):extend()
      local highlight = require("lualine.highlight")
      local dap = require("dap")
      local attached = false
      local stopped = false

      dap.listeners.after["event_initialized"]["me"] = function()
        attached = true
      end

      dap.listeners.after["event_terminated"]["me"] = function()
        attached = false
        stopped = false
      end

      dap.listeners.after["event_exited"]["me"] = function()
        attached = false
        stopped = false
      end

      dap.listeners.after["event_stopped"]["me"] = function()
        stopped = true
      end

      dap.listeners.after["event_continued"]["me"] = function()
        stopped = false
      end

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
        local status = custom_fname.super.update_status(self)
        local modified = vim.bo.modified
        if modified and self.status_colors.modified then
          status = highlight.component_format_highlight(self.status_colors.modified) .. status
        end
        if attached then
          status = status .. " (Attached)"
        end
        if stopped then
          status = status .. " (Stopped)"
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
          lualine_x = {'filesize'},
          lualine_y = {'filetype'},
          lualine_z = {'progress', 'location'}
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

      vim.api.nvim_set_hl(0, "lualine_c_diagnostics_error_normal", { fg = "#de5d68", bold = true })
    end,
  },
}
