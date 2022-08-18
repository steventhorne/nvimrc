local map_key = require("utils").map_key

-- leader mappings
map_key("n", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- movement mappings
map_key("", "<UP>", "<NOP>")
map_key("", "<DOWN>", "<NOP>")
map_key("", "<LEFT>", "<NOP>")
map_key("", "<RIGHT>", "<NOP>")
map_key("", "<C-J>", "<C-W>j")
map_key("", "<C-K>", "<C-W>k")
map_key("", "<C-H>", "<C-W>h")
map_key("", "<C-L>", "<C-W>l")

-- clear search highlighting
map_key("", "<LEADER><CR>", ":noh<CR>")

-- escape mappings
map_key("i", "jj", "<ESC>")
map_key("i", "JJ", "<ESC>")
map_key("i", "jk", "<ESC>")
map_key("i", "kj", "<ESC>")
map_key("i", "JK", "<ESC>")
map_key("i", "KJ", "<ESC>")

vim.cmd([[
  function! ToggleTerminal()
    let termname = "terminal_bottom"
    let pane = bufwinnr(termname)
    let curpane = winnr()
    let buf = bufexists(termname)
    if pane > 0
      if pane == curpane
        :exe pane . "wincmd c"
      else
        :exe pane . "wincmd w"
      endif
    elseif buf > 0
      :exe "bot sp"
      :exe "buffer " . termname
      :exe nobl
      call feedkeys("10\<C-W>_")
    else
      :exe "bot split"
      :terminal
      :exe "f " termname
      call feedkeys("10\<C-W>_")
    endif
  endfunction
]])

vim.cmd([[
  function! ToggleTerminalSize()
    let termname = "terminal_bottom"
    let pane = bufwinnr(termname)
    let curpane = winnr()
    if pane > 0
      if pane != curpane
        :exe pane . "wincmd w"
      endif
      let termsize = "normal"
      if exists("w:term_size")
        let termsize = w:term_size
      endif
      if termsize == "normal"
        call feedkeys("\<C-W>_")
        let termsize = "full"
      else
        call feedkeys("10\<C-W>_")
        let termsize = "normal"
      endif
      let w:term_size = termsize
    endif
  endfunction
]])

-- terminal mappings
map_key("", "<LEADER>;", ":call ToggleTerminal()<CR>")
map_key("", "<LEADER>:", ":call ToggleTerminalSize()<CR>")
map_key("t", "<ESC>", "<C-\\><C-N>")
map_key("t", "jj", "<C-\\><C-N>")
map_key("t", "JJ", "<C-\\><C-N>")
map_key("t", "jk", "<C-\\><C-N>")
map_key("t", "kj", "<C-\\><C-N>")
map_key("t", "JK", "<C-\\><C-N>")
map_key("t", "KJ", "<C-\\><C-N>")
map_key("t", "<C-R>", "'<C-\\><C-N>\"'.nr2char(getchar()).'pi'", { noremap = true, silent = true, expr = true })
map_key("t", "<C-J>", "<C-\\><C-N><C-W>j")
map_key("t", "<C-K>", "<C-\\><C-N><C-W>k")
map_key("t", "<C-H>", "<C-\\><C-N><C-W>h")
map_key("t", "<C-L>", "<C-\\><C-N><C-W>l")

-- goneovim mappings
if vim.fn.exists("g:gonvim_running") > 0 then
  map_key("n", "gw", "v:count > 0 ? '<ESC>:GonvimWorkspaceSwitch ' .. v:count .. '<CR>' : '<ESC>:GonvimWorkspaceNext<CR>'", { noremap = true, silent = true, expr = true })
  map_key("n", "gW", ":GonvimWorkspacePrevious<CR>")
end

