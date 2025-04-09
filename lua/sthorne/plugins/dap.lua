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
      local node2_adapter = {
        type = "executable",
        command = "node",
        args = { masonPackages.."/node-debug2-adapter/out/src/nodeDebug.js" },
        options = {
          detached = vim.fn.has("win32") == 0,
        }
      }

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

      -- .NET
      local coreclr_adapter = {
        type = "executable",
        command = utils.get_mason_cmd("netcoredbg"),
        args = { "--interpreter=vscode" },
        options = {
          detached = vim.fn.has("win32") == 0,
        }
      }

      local cs_config = {
        {
          name = "Attach to .NET Core",
          type = "coreclr",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
        {
          type = "coreclr",
          name = "Launch .NET Core",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
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

      dap.adapters.node2 = node2_adapter
      dap.adapters.coreclr = coreclr_adapter
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
