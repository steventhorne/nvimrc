return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          register_configurations = function(paths)
            require("dap").configurations.dart = {
              {
                name = "Flutter",
                request = "launch",
                type = "dart",
                flutterMode = "debug",
                cwd = "${workspaceFolder}",
                program = "${file}",
              },
            }
          end
        }
      })
    end,
  },
}
