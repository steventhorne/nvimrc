return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", },
      { "nvim-neotest/nvim-nio" },
      { "rcarriga/nvim-dap-ui" },
    },
    config = function()
      require("nvim-dap-virtual-text").setup({
        highlight_new_as_changed = true,
      })

      require("dapui").setup({})

      local masonPackages = vim.fn.stdpath("data").."/mason/packages"
      local dap = require("dap")
      local utils = require("sthorne.utils")

      -- node
      local js_adapter = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = { masonPackages.."/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}", "127.0.0.1" },
        }
      }

      local js_config = {
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          port = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = "Attach to port: ",
                default = 9229,
              }, function(port)
                if port == nil or port == 0 then
                  return
                else
                  coroutine.resume(co, port)
                end
              end)
            end)
          end,
          restart = true,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }

      -- .NET
      local netcoredbg_adapter = {
        type = "executable",
        command = utils.get_mason_cmd("netcoredbg"),
        args = { "--interpreter=vscode" },
        options = {
          detached = false,
        }
      }

      local cs_config = {
        {
          name = "Attach to .NET",
          type = "netcoredbg",
          request = "attach",
          processId = "${command:pickProcess}",
          cwd = "${workspaceFolder}"
        },
        {
          type = "netcoredbg",
          name = "Launch .NET",
          request = "launch",
          ---@diagnostic disable-next-line: redundant-parameter
          program = function()
            return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }

      -- golang
      local go_adapter = {
        type = "server",
        port = "${port}",
        executable = {
          command = utils.get_mason_cmd("dlv"),
          args = {"dap", "-l", "127.0.0.1:${port}"},
        },
        options = {
          detached = vim.fn.has("win32") == 0,
        }
      }

      local go_config = {
        {
          name = "Attach to Go",
          type = "go",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      dap.adapters["pwa-node"] = js_adapter
      dap.adapters["node-terminal"] = js_adapter
      dap.adapters.netcoredbg = netcoredbg_adapter
      dap.adapters.go = go_adapter

      dap.configurations.javascript = js_config
      dap.configurations.typescript = js_config
      dap.configurations.cs = cs_config
      dap.configurations.go = go_config

      vim.fn.sign_define("DapBreakpoint", { text="", texthl="DiagnosticError", linehl="DiagnosticVirtualTextError", numhl="" })
      vim.fn.sign_define("DapBreakpointCondition", { text="", texthl="DiagnosticError", linehl="DiagnosticVirtualTextError", numhl="" })
      vim.fn.sign_define("DapBreakpointRejected", { text="", texthl="DiagnosticError", linehl="", numhl="" })
      vim.fn.sign_define("DapStopped", { text="", texthl="DiagnosticError", linehl="DiagnosticVirtualTextWarn", numhl="" })

      vim.keymap.set("n", "<F5>", "<CMD>lua require(\"dap\").continue()<CR>", { silent = true })
      vim.keymap.set("n", "<F6>",  "<CMD>lua require(\"dapui\").toggle()<CR>", { silent = true })
      vim.keymap.set("n", "<F7>", "<CMD>lua require(\"sthorne.utils.dap\").toggle_hover()<CR>", { silent = true })
      vim.keymap.set("n", "<F9>", "<CMD>lua require(\"dap\").toggle_breakpoint()<CR>", { silent = true })
      vim.keymap.set("n", "<S-F9>", "<CMD>lua require(\"dap\").clear_breakpoints()<CR>", { silent = true })
      vim.keymap.set("n", "<C-F9>", "<CMD>lua require(\"dap\").list_breakpoints()<CR>", { silent = true })
      vim.keymap.set("n", "<F10>", "<CMD>lua require(\"dap\").step_over()<CR>", { silent = true })
      vim.keymap.set("n", "<F11>", "<CMD>lua require(\"dap\").step_into()<CR>", { silent = true })
      vim.keymap.set("n", "<F12>", "<CMD>lua require(\"dap\").step_out()<CR>", { silent = true })
    end
  },
}
