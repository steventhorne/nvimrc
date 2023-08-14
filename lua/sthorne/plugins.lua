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

local function getConfig(path)
  return require("sthorne.plugins/" .. path).config
end

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  use({
    "navarasu/onedark.nvim",
    config = getConfig("onedark")
  })

  use({
    "kevinhwang91/nvim-bqf",
    ft = "qf"
  })

  use({
    "laytan/cloak.nvim",
    config = getConfig("cloak")
  })

  use({
    "numToStr/Comment.nvim",
    config = getConfig("comment")
  })

  use("github/copilot.vim")

  use({
    "mfussenegger/nvim-dap",
    requires = {
      { "theHamsta/nvim-dap-virtual-text", },
      { "rcarriga/nvim-dap-ui" },
    },
    config = getConfig("dap")
  })

  use({ "elihunter173/dirbuf.nvim" })

  use({
    "mhartington/formatter.nvim",
    config = getConfig("formatter")
  })

  use({
    "tpope/vim-fugitive",
    config = getConfig("fugitive")
  })

  use({
    "lewis6991/gitsigns.nvim",
    config = getConfig("gitsigns")
  })

  use({
    "mfussenegger/nvim-lint",
    config = getConfig("lint")
  })

  use("ggandor/lightspeed.nvim")

  use({
    "neovim/nvim-lspconfig",
    requires = {
      { "simrat39/rust-tools.nvim" },
    },
    config = getConfig("lsp")
  })

  -- use({
  --   "j-hui/fidget.nvim",
  --   config = function() require("fidget").setup() end
  -- })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", after="nvim-cmp" },
      { "hrsh7th/cmp-buffer", after="nvim-cmp" },
      { "hrsh7th/cmp-path", after="nvim-cmp" },
      { "hrsh7th/cmp-cmdline", after="nvim-cmp" },
      { "rcarriga/cmp-dap", after="nvim-cmp" },
      { "hrsh7th/cmp-vsnip", after="nvim-cmp" },
      { "hrsh7th/vim-vsnip", after="nvim-cmp" },
      { "hrsh7th/vim-vsnip-integ", after="nvim-cmp" },
    },
    config = getConfig("cmp")
  })

  use({
    "nvim-lualine/lualine.nvim",
    config = getConfig("lualine")
  })

  use({
    "williamboman/mason.nvim",
    config = getConfig("mason")
  })

  use({
    "echasnovski/mini.starter",
    branch = "stable",
    config = getConfig("starter"),
  })

  use({
    "echasnovski/mini.sessions",
    branch = "stable",
    config = getConfig("sessions"),
  })

  use({
    "mawkler/modicator.nvim",
    after = "onedark.nvim",
    config = getConfig("modicator")
  })

  use("matze/vim-move")

  use({ "Hoffs/omnisharp-extended-lsp.nvim" })

  require("sthorne.plugins.qf")

  use({ "tpope/vim-sleuth" })

  use({
    "kylechui/nvim-surround",
    config = getConfig("surround")
  })

  require("sthorne.plugins.tabline").setup()

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-fzf-native.nvim", run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-dap.nvim" },
    },
    config = getConfig("telescope")
  })

  use({
    "nvim-tree/nvim-tree.lua",
    config = getConfig("tree")
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    requires = {
      { "nvim-treesitter/playground", after="nvim-treesitter" },
    },
    config = getConfig("treesitter")
  })

  use("mbbill/undotree")

  if packer_bootstrap then
    require("packer").sync()
  end
end)
