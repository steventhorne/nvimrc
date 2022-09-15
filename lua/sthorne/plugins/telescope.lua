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

  local default_picker_opts = {
    attach_mappings = attach_mappings,
    layout_config = {
      preview_width = 0.4,
    },
    prompt_title = "",
    results_title = "",
    preview_title = "",
    show_line = false,
  }

  require("telescope").setup({
    defaults = {
      layout_config = {
        width = 0.9,
      },
      path_display = {
        truncate = 30,
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

  local map_key = require("sthorne.utils").map_key
  map_key('', "<LEADER>nf", ":Telescope find_files<CR>")
  map_key('', "<LEADER>nF", ":Telescope live_grep<CR>")
  map_key('', "<LEADER>ng", ":Telescope git_files<CR>")
  map_key('', "<LEADER>ns", ":Telescope git_status<CR>")
  map_key('', "<LEADER>nt", ":Telescope lsp_document_symbols<CR>")
  map_key('', "<LEADER>nb", ":Telescope buffers<CR>")
end

return {
  config = configure
}
