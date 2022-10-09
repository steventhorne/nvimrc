local ensure_packer = function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd([[ packadd packer.nvim ]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require("packer")

local function getConfig(path)
  return require("sthorne.plugins/" .. path).config
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")

  use({
    "navarasu/onedark.nvim",
    config = getConfig("onedark")
  })

  use({
    "numToStr/Comment.nvim",
    config = getConfig("comment")
  })

  use({ "github/copilot.vim" })

  use({
    "mfussenegger/nvim-dap",
    requires = {
      { "theHamsta/nvim-dap-virtual-text" },
    },
    config = getConfig("dap")
  })

  use({ "tpope/vim-fugitive" })

  use({
    "lewis6991/gitsigns.nvim",
    config = getConfig("gitsigns")
  })

  use({ "ggandor/lightspeed.nvim" })

  use({
    "neovim/nvim-lspconfig",
    requires = {
      { "ray-x/lsp_signature.nvim" },
      { "simrat39/rust-tools.nvim" },
    },
    config = getConfig("lsp")
  })

  use({
    "j-hui/fidget.nvim",
    config = function() require("fidget").setup() end
  })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer", after="nvim-cmp" },
      { "hrsh7th/cmp-path", after="nvim-cmp" },
      { "hrsh7th/cmp-cmdline", after="nvim-cmp" },
      { "rcarriga/cmp-dap", after="nvim-cmp" },
      { "hrsh7th/cmp-vsnip", after="nvim-cmp" },
      { "hrsh7th/vim-vsnip", after="nvim-cmp" },
    },
    config = getConfig("cmp")
  })

  use({
    "nvim-lualine/lualine.nvim",
    config = getConfig("lualine")
  })

  use({ "matze/vim-move" })

  use({
    "preservim/nerdtree",
    config = getConfig("nerdtree")
  })

  use({ "tpope/vim-sleuth" })

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-dap.nvim" },
    },
    config = getConfig("telescope")
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    config = getConfig("treesitter")
  })

  if packer_bootstrap then
    packer.sync()
  end
end)
