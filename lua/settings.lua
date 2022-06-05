vim.o.syntax = 'on'

vim.bo.autoindent = true
vim.bo.smartindent = true
vim.cmd([[ set backspace=indent,eol,start ]])
vim.o.completeopt='menuone,noinsert,noselect'
vim.o.smarttab = true

vim.cmd([[ set nrformats-=octal ]])

vim.o.ttimeout = true
vim.o.ttimeoutlen = 100

vim.o.incsearch = true

vim.o.laststatus = 2

vim.o.ruler = true
vim.o.wildmenu = true

vim.o.scrolloff = true
vim.o.sidescrolloff = 5

vim.cmd([[ set display+=lastline ]])

vim.cmd([[
  if &encoding ==# 'latin1' && has('gui_running')
    set encoding=utf-8
  endif
]])

vim.o.autoread = true

vim.cmd([[
  if &t_Co == 8 && $TERM !~# '^Eterm'
    set t_Co=16
  endif
]])

vim.o.termguicolors = true
vim.o.errorbells = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.hidden = true

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.signcolumn = 'auto'
vim.wo.wrap = false

