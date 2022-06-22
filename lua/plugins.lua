local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

local packer = require("packer")

vim.cmd [[packadd packer.nvim]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return packer.startup(function(use)
  use "wbthomason/packer.nvim"

  local plugins = {
    "code-dark",
    "comment",
    "copilot",
    "dap",
    "fugitive",
    "gitsigns",
    "lightspeed",
    "lsp",
    "lualine",
    "move",
    "nerdtree",
    "sleuth",
    "telescope",
    "treesitter",
    "vsnip",
  }

  for _, plugin in ipairs(plugins) do
    require("plugins/" .. plugin).load(use)
  end

  if packer_bootstrap then
    packer.sync()
  end
end)

