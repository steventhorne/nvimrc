local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

local disabled_plugins = {
  "gzip",
  "netrwPlugin",
  "rplugin",
  "tarPlugin",
  "tohtml",
  "tutor",
  "zipPlugin",
  "spellfile",
}

local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
if is_windows then
  table.insert(disabled_plugins, "man")
end

require("lazy").setup({
  ui = { border = "rounded" },
  change_detection = { notify = false },
  rocks = { enabled = false },
  spec = { { import = "sthorne/plugins" }, },
  install = { colorscheme = { "onedark" } },
  performance = { rtp = { disabled_plugins = disabled_plugins } }
})
