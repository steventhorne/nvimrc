local default_picker_opts = {
  attach_mappings = attach_mappings,
  layout_config = {
    preview_width = 0.4,
  },
  show_line = false,
  show_untracked = true,
}

local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")

  return vim.v.shell_error == 0
end

local function git_files_with_fallback(all)
  local builtin = require("telescope.builtin")
  local opts = vim.tbl_deep_extend("force", default_picker_opts, {
    hidden = true,
    no_ignore = all,
    no_ignore_parent = all,
  })
  if is_git_repo() and not all then
    builtin.git_files(opts)
  else
    builtin.find_files(opts)
  end
end

local function configure()
  local actions = require("telescope.actions")
  local actions_set = require("telescope.actions.set")

  require("telescope").load_extension("ui-select")
  require("telescope").load_extension("dap")

  local attach_mappings = function(_, map)
    map("n", "q", actions.close)
    actions_set.select:enhance({
      post = function()
        vim.cmd(":normal! zx")
        vim.cmd(":normal! zR")
      end,
    })
    return true
  end

  require("telescope").setup({
    defaults = {
      layout_config = {
        width = 0.9,
      },
      path_display = {
        truncate = 30,
      },
      file_ignore_patterns = {
        "node_modules",
        "%.meta",
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({
          attach_mappings = attach_mappings,
          prompt_title = "",
          results_title = "",
          preview_title = "",
        })
      },
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }
    },
    pickers = {
      buffers = {
        attach_mappings = function(_, map)
          attach_mappings(_, map)
          map("n", "d", actions.delete_buffer)
          return true
        end,
        preview_width = 0.4,
        prompt_title = "",
        results_title = "",
        preview_title = "",
      },
      find_files = default_picker_opts,
      live_grep = default_picker_opts,
      git_files = default_picker_opts,
      git_status = default_picker_opts,
      lsp_document_symbols = default_picker_opts,
      lsp_definitions = default_picker_opts,
      lsp_references = default_picker_opts,
      lsp_implementations = default_picker_opts,
      dap = default_picker_opts,
    }
  })

  require("telescope").load_extension("fzf")

  vim.keymap.set('', "<LEADER>nf", ":Telescope current_buffer_fuzzy_find<CR>", { silent = true })
  vim.keymap.set('', "<LEADER>nF", ":Telescope live_grep<CR>", { silent = true })
  vim.keymap.set('', "<LEADER>ns", ":Telescope git_status<CR>", { silent = true })
  vim.keymap.set('', "<LEADER>nt", ":Telescope lsp_document_symbols<CR>", { silent = true })
  vim.keymap.set('', "<LEADER>nb", ":Telescope buffers<CR>", { silent = true })
  vim.keymap.set('', "<LEADER>ng", function() require("sthorne.plugins.telescope").git_files_with_fallback(false) end, { silent = true })
  vim.keymap.set('', "<LEADER>nG", function() require("sthorne.plugins.telescope").git_files_with_fallback(true) end, { silent = true })
  vim.keymap.set('', "<LEADER>nh", ":Telescope help_tags<CR>", { silent = true })
end

return {
  config = configure,
  git_files_with_fallback = git_files_with_fallback,
}
