local sidebar
local function toggle_sidebar()
  if (not sidebar) then
    local widgets = require("dap.ui.widgets");
    sidebar = widgets.sidebar(widgets.scopes);
  end
  sidebar.toggle()
end

local hover
local function toggle_hover()
  if (not hover) then
    local widgets = require("dap.ui.widgets");
    hover = widgets.cursor_float(widgets.expression);
  end
  hover.toggle()
end

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
  map_key("n", "<F6>",  "<CMD>lua require\"plugins.dap\".toggle_sidebar()<CR>")
  map_key("n", "<F7>", "<CMD>lua require\"plugins.dap\".toggle_hover()<CR>")
  map_key("n", "<F8>", "<CMD>lua require\"dap\".repl.toggle()<CR>")
  map_key("n", "<F9>", "<CMD>lua require\"dap\".toggle_breakpoint()<CR>")
  map_key("n", "<S-F9>", "<CMD>lua require\"dap\".clear_breakpoints()<CR>")
  map_key("n", "<C-F9>", "<CMD>lua require\"dap\".list_breakpoints()<CR>")
  map_key("n", "<F10>", "<CMD>lua require\"dap\".step_over()<CR>")
  map_key("n", "<F11>", "<CMD>lua require\"dap\".step_into()<CR>")
  map_key("n", "<F12>", "<CMD>lua require\"dap\".step_out()<CR>")

  local js_config = {
    {
      name = "Attach to 9229",
      type = "node2",
      request = "attach",
      restart = true,
      port = 9229,
    },
    {
      name = "Attach to 9228",
      type = "node2",
      request = "attach",
      restart = true,
      port = 9228,
    },
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
  }

  dap.configurations.javascript = js_config
  dap.configurations.typescript = js_config
end

local function load(use)
  use({
    "mfussenegger/nvim-dap",
    config = configure,
  })

  use({
    "theHamsta/nvim-dap-virtual-text",
    config = function ()
      require("nvim-dap-virtual-text").setup({})
    end,
  })
end

return {
  load = load,
  toggle_sidebar = toggle_sidebar,
  toggle_hover = toggle_hover,
}

