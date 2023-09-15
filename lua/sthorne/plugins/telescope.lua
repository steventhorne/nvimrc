local is_inside_work_tree = {}

local function is_git_repo()
  local cwd = vim.loop.cwd()
  if is_inside_work_tree[cwd] == nil then
    local ok, err = vim.loop.fs_stat(cwd.."/.git")
    is_inside_work_tree[cwd] = ok
  end

  return is_inside_work_tree[cwd]
end

local function git_files_with_fallback(all)
  local builtin = require("telescope.builtin")
  local opts = {
    hidden = true,
    no_ignore = all,
    no_ignore_parent = all,
  }
  print(is_git_repo())
  print(all)
  if is_git_repo() and not all then
    builtin.git_files()
  else
    builtin.find_files(opts)
  end
end

local function configure()
  local actions = require("telescope.actions")
  local actions_set = require("telescope.actions.set")

  require("telescope").setup({
    defaults = {
      results_title = false,
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
      mappings = {
        n = {
          ["q"] = require("telescope.actions").close,
        },
        i = {
          ["<esc>"] = require("telescope.actions").close,
        }
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({
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
        mappings = {
          n = {
            ["d"] = actions.delete_buffer,
          },
        },
        preview_width = 0.4,
        prompt_title = "",
        results_title = "",
        preview_title = "",
      },
      -- find_files = {},
      -- live_grep = {},
      -- git_files = {},
      git_status = {
        preview_width = 0.4,
        git_icons = {
          added = "A",
          changed = "M",
          deleted = "D",
        },
      },
      lsp_document_symbols = {
        preview_width = 0.4,
        show_line = false,
      },
      lsp_definitions = {
        preview_width = 0.4,
        show_line = false,
        reuse_win = true,
      },
      lsp_references = {
        preview_width = 0.4,
        show_line = false,
      },
      lsp_implementations = {
        preview_width = 0.4,
        show_line = false,
        reuse_win = true,
      },
    }
  })

  require("telescope").load_extension("ui-select")
  require("telescope").load_extension("dap")
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("flutter")

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
