-- disable mouse
vim.opt.mouse = ""

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5

vim.cmd([[
  if &t_Co == 8 && $TERM !~# '^Eterm'
    set t_Co=16
  endif
]])

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false

vim.opt.signcolumn = "yes"
vim.opt.startofline = true

vim.cmd([[ set diffopt=filler,iwhite,vertical,internal,algorithm:patience,indent-heuristic,algorithm:histogram ]])

vim.cmd([[ let g:rust_recommended_style=0 ]])

vim.cmd([[
  au! BufRead,BufNewFile *.astro set filetype=astro
]])

if vim.fn.has("win32") > 0 then
  vim.opt.shell = "powershell.exe"
end

vim.api.nvim_create_user_command("Fresh", "%bd|e#|bd#|'\"", {})
