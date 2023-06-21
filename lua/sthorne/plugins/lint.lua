local configure = function()
  local lint = require("lint")

  local mason_root = vim.fn.stdpath("data") .. "/mason/packages"

  local eslint_d_root = mason_root .. "eslint_d/node_modules/.bin"
  local eslint_d_exe = vim.fn.has("win32") and "eslint_d.cmd" or "eslint_d"

  local es_pattern = [[%s*(%d+):(%d+)%s+(%w+)%s+(.+%S)%s+(%S+)]]
  local es_groups = { 'lnum', 'col', 'severity', 'message', 'code' }
  local es_severity_map = {
    ['error'] = vim.diagnostic.severity.ERROR,
    ['warn'] = vim.diagnostic.severity.WARN,
    ['warning'] = vim.diagnostic.severity.WARN,
  }

  lint.linters.es = {
    cmd = eslint_d_exe,
    args = {},
    stdin = true,
    stream = 'stdout',
    ignore_exitcode = true,
    parser = require("lint.parser").from_pattern(es_pattern, es_groups, es_severity_map, { ['source'] = 'eslint_d' })
  }

  require("lint").linters_by_ft = {
    javascript = {"eslint_d"},
    typescript = {"eslint_d"},
    rust = {"cargo", "clippy"},
    lua = {"luacheck"},
    python = {"flake8"},
    sh = {"shellcheck"},
    vim = {"vint"},
  }

  -- vim.cmd([[noremap <leader>f mF:%!eslint_d --stdin --fix-to-stdout<CR>`F]])
end

return {
  config = configure,
}
