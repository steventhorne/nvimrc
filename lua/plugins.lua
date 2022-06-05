local packer = require('packer')
local map_key = require('utils').map_key
local load_module = require('utils').load_module

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return packer.startup(function()
  use 'wbthomason/packer.nvim'

  require('plugins/ale').load(use)
  require('plugins/autopairs').load(use)
  require('plugins/comment').load(use)
  require('plugins/gitsigns').load(use)
  require('plugins/indent-blankline').load(use)
  require('plugins/nerdtree').load(use)
  require('plugins/telescope').load(use)
  require('plugins/vim-code-dark').load(use)
  require('plugins/vim-fugitive').load(use)
  require('plugins/vim-move').load(use)
  require('plugins/vim-surround').load(use)
  --require('plugins/lsp').load(use)

  if packer_bootstrap then
    packer.sync()
  end
end)

