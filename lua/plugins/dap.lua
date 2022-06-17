local function configure()
  local dap = require("dap")
  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/dap/vscode-node-debug2/out/src/nodeDebug.js" },
  }

  vim.fn.sign_define("DapBreakpoint", { text="", texthl="DiagnosticError", linehl="", numhl="" })
  vim.fn.sign_define("DapBreakpointCondition", { text="", texthl="DiagnosticError", linehl="", numhl="" })

  local map_key = require("utils").map_key
  map_key("n", "<F5>", "<CMD>lua require\"dap\".continue()<CR>")
  map_key("n", "<F9>", "<CMD>lua require\"dap\".toggle_breakpoint()<CR>")
  map_key("n", "<F10>", "<CMD>lua require\"dap\".step_over()<CR>")
  map_key("n", "<F11>", "<CMD>lua require\"dap\".step_into()<CR>")
  map_key("n", "<F12>", "<CMD>lua require\"dap\".step_out()<CR>")

  local js_config = {
    {
      name = "Launch",
      type = "node2",
      request = "launch",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
    {
      name = "Attach to process",
      type = "node2",
      request = "attach",
      processId = require("dap.utils").pick_process,
    },
  }

  dap.configurations.javascript = js_config
  dap.configurations.typescript = js_config
end

local function load(use)
  use({
    "mfussenegger/nvim-dap",
    config = configure,
  })
end

return {
  load = load,
}

