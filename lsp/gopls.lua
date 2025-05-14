return {
  cmd = {
    require("sthorne.utils").get_mason_cmd("gopls"),
  },
  settings = {
    gopls = {
      staticcheck = true,
    },
  },
  root_dir = require("lspconfig.util").root_pattern({ "go.work", "go.mod", ".git" }),
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      local au_format_on_save = vim.api.nvim_create_augroup("LspFormatting", {})
      vim.api.nvim_clear_autocmds({ group = au_format_on_save, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = au_format_on_save,
        buffer = bufnr,
        callback = function()
          local params = vim.lsp.util.make_range_params(0, 'utf-8')
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({async = false})
        end
      })
    end
  end
}
