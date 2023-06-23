vim.api.nvim_create_user_command("QF",
  function(opts)
    if opts.args == "hint" or opts.args == "all" then
      vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.HINT } })
    elseif opts.args == "info" then
      vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.INFO } })
    elseif opts.args == "warn" then
      vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } })
    elseif opts.args == "error" then
      vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.ERROR } })
    end
  end,
  {
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos)
      return { "all", "hint", "info", "warn", "error" }
    end
  }
)
