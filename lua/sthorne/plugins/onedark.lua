return {
  {
    "navarasu/onedark.nvim",
    config = function()
      local au_onedark = vim.api.nvim_create_augroup("OneDark", { clear = true })
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = au_onedark,
        pattern = "*:*",
        callback = function()
          local mode = vim.api.nvim_get_mode().mode
          local cp_hl

          if mode == "i" then
            cp_hl = vim.api.nvim_get_hl(0, { name = "InsertMode" })
          elseif mode == "v" or mode == "V" then
            cp_hl = vim.api.nvim_get_hl(0, { name = "VisualMode" })
          elseif mode == "c" then
            cp_hl = vim.api.nvim_get_hl(0, { name = "CommandMode" })
          elseif mode == "s" then
            cp_hl = vim.api.nvim_get_hl(0, { name = "SelectMode" })
          elseif mode == "R" then
            cp_hl = vim.api.nvim_get_hl(0, { name = "ReplaceMode" })
          elseif mode == "t" then
            cp_hl = vim.api.nvim_get_hl(0, { name = "TermMode" })
          else
            cp_hl = vim.api.nvim_get_hl(0, { name = "NormalMode" })
          end

          vim.api.nvim_set_hl(0, "CursorLineNr", cp_hl)
        end
      })
      require("onedark").setup({
        style = "darker",

        highlights = {
          -- general
          ["Title"] = { fg = "$red", fmt = "bold" },
          ["CursorLineNr"] = { fg = "$green", fmt = "bold" },
          -- modes
          ["NormalMode"] = { fg = "$green", fmt = "bold" },
          ["InsertMode"] = { fg = "$blue", fmt = "bold" },
          ["VisualMode"] = { fg = "$purple", fmt = "bold" },
          ["CommandMode"] = { fg = "$yellow", fmt = "bold" },
          ["SelectMode"] = { fg = "$cyan", fmt = "bold" },
          ["ReplaceMode"] = { fg = "$red", fmt = "bold" },
          ["TermMode"] = { fg = "$green", fmt = "bold" },
          -- nvim-cmp
          ["PmenuSel"] = { fg = "$bg1", bg = "$blue" },
          ["CmpItemAbbrMatch"] = { fg = "$blue", fmt = "bold" },
          ["CmpItemAbbrMatchFuzzy"] = { fg = "$blue", fmt = "bold" },
          ["CmpItemKindFile"] = { fg = "$blue", fmt = "bold" },
          ["CmpItemKindFolder"] = { fg = "$blue", fmt = "bold" },
          -- tabs
          ["TabLine"] = { fg = "$fg", bg = "$bg3" },
          ["TabLineSelAccent"] = { fg = "$bg1", bg = "$blue" },
          ["TabLineFill"] = { bg = "$bg3" },
          ["TabLineSel"] = { fg = "$fg", bg = "$bg0", fmt = "bold" },
          ["NormalFloat"] = { fg = "$fg", bg = "$bg0" },
          ["FloatBorder"] = { fg = "$cyan", bg = "$bg0" },
        },

        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "italic",
          variables = "none",
        },

        lualine = {
          transparent = true,
        },

        diagnostics = {
          darker = false,
          undercurl = true,
          background = true,
        },

        -- overrides = function(c)
        --   return {
        --     -- general
        --     Title = { fg = c.red0, style = style.Bold },
        --     -- modes
        --     NormalMode = { fg = c.green0, style = style.Bold },
        --     InsertMode = { fg = c.blue0, style = style.Bold },
        --     VisualMode = { fg = c.purple0, style = style.Bold },
        --     CommandMode = { fg = c.red0, style = style.Bold },
        --     SelectMode = { fg = c.cyan0, style = style.Bold },
        --     ReplaceMode = { fg = c.red2, style = style.Bold },
        --     TermMode = { fg = c.green0, style = style.Bold },
        --     -- quickfix
        --     qfLineNr = { fg = c.fg_gutter },
        --     -- nvim-cmp
        --     PmenuSel = { fg = c.bg1, bg = c.blue0 },
        --     CmpItemAbbrMatch = { fg = c.blue0, style = style.Bold },
        --     CmpItemAbbrMatchFuzzy = { link = 'CmpItemAbbrMatch' },
        --     CmpItemKindFile = { link = 'NvimTreeFolderIcon' },
        --     CmpItemKindFolder = { link = 'CmpItemKindFile' }
        --   }
        -- end
      })
      require("onedark").load()
    end,
  },
}
