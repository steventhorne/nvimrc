local function configure()
  local cmp = require("cmp")

  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ""
  vim.g.vsnip_snippet_dir = vim.fn.stdpath("config").."/snippets"

  vim.keymap.set("i", "<C-E>", "<NOP>", { silent = true })

  local function check_copilot()
    local suggestion = vim.fn["copilot#GetDisplayedSuggestion"]()
    if suggestion.text ~= "" then
      local copilot_keys = vim.fn["copilot#Accept"]()
      if copilot_keys ~= "" then
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
        return true
      end
    end
    return false
  end

  local win_highlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None"

  local cmp_opts = {
    mapping = cmp.mapping.preset.insert({
      ["<C-N>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({}),
      ["<C-E>"] = cmp.mapping.abort(),
      ["<TAB>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif check_copilot() then
        elseif vim.fn["vsnip#available"](1) > 0 then
          if vim.fn["vsnip#jumpable"](1) > 0 then
            vim.fn.feedkeys(string.format("%c%c%c(vsnip-jump-next)", 0x80, 253, 83))
          end
        else
          fallback()
        end
      end,
      ["<S-TAB>"] = function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
            return
        elseif vim.fn["vsnip#available"](1) > 0 then
          if vim.fn["vsnip#jumpable"](1) > 0 then
            vim.fn.feedkeys(string.format("%c%c%c(vsnip-jump-prev)", 0x80, 253, 83))
          end
        end
        fallback()
      end,
    }),
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      completion = {
        border = "rounded",
        winhighlight = win_highlight,
      },
      documentation = {
        border = "rounded",
        winhighlight = win_highlight,
      },
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "vsnip" },
      { name = "nvim_lsp_signature_help" },
    }, {
      { name = "buffer" },
    }),
    completion = {
      completeopt = "menu,menuone,noselect",
    },
    preselect = cmp.PreselectMode.None,
  }

  cmp.setup(cmp_opts);
  cmp.setup.filetype({ "dap-repl" }, {
    sources = {
      { name = "dap" },
    },
  })

  cmp.setup.filetype({ "sql" }, {
    sources = {
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    }
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    })
  })
end

return {
  config = configure
}
