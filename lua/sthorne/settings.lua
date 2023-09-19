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

vim.opt.hlsearch = true
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

-- vim.cmd([[ au! BufRead,BufNewFile *.cshtml set filetype=cshtml syntax=html ]])
vim.cmd([[ au! BufRead,BufNewFile *.astro set filetype=astro ]])
vim.cmd([[ au! BufRead,BufNewFile *.tt set filetype=tintin ]])

if vim.fn.has("win32") > 0 then
  vim.opt.shell = "powershell.exe"
end

local delete_hidden_buffers = function()
  local bufs = vim.api.nvim_list_bufs()
  local closed = 0
  for i,v in ipairs(bufs) do
    local info = vim.fn.getbufinfo(v)
    if info ~= nil then
      info = info[1]
    end
    if vim.fn.bufexists(v) and next(vim.fn.win_findbuf(v)) == nil and (info == nil or info.changed == 0) then
      vim.cmd.bwipeout({ count = v })
      if info.listed == 1 then
        closed = closed + 1
      end
    end
  end
  print("Closed " .. closed .. " hidden buffers")
end

-- delete all but visible buffers
vim.api.nvim_create_user_command("Fresh", delete_hidden_buffers, {})

-- delete all but current buffer
-- vim.api.nvim_create_user_command("Fresh", "%bd|e#|bd#|'\"", {})
