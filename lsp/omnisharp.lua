return {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<LEADER>ld", ":lua require('omnisharp_extended').lsp_definitions()<CR>", { noremap = true, silent = true })

    local function to_snake_case(str)
      return string.gsub(str, "%s*[- ]%s*", "_")
    end
    -- fix tokenModifiers and tokenTypes that don't conform to LSP semantic tokens spec
    -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
    for i, v in ipairs(tokenModifiers) do
      tokenModifiers[i] = to_snake_case(v)
    end
    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
    for i, v in ipairs(tokenTypes) do
      tokenTypes[i] = to_snake_case(v)
    end
    client.server_capabilities.semanticTokensProvider = {
      full = vim.empty_dict(),
      legend = {
        tokenModifiers = tokenModifiers,
        tokenTypes = tokenTypes,
      },
      range = true,
    }
  end
}
