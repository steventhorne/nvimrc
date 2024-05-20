-- leader mappings
vim.keymap.set("", "<SPACE>", "<NOP>", { silent = true })
vim.g.mapleader = " "

-- disable Q EX mode
vim.keymap.set("n", "Q", "<NOP>", { silent = true })

-- movement mappings
vim.keymap.set("", "<UP>", "<NOP>", { silent = true })
vim.keymap.set("", "<DOWN>", "<NOP>", { silent = true })
vim.keymap.set("", "<LEFT>", "<NOP>", { silent = true })
vim.keymap.set("", "<RIGHT>", "<NOP>", { silent = true })
vim.keymap.set("", "<C-J>", "<C-W>j", { silent = true })
vim.keymap.set("", "<C-K>", "<C-W>k", { silent = true })
vim.keymap.set("", "<C-H>", "<C-W>h", { silent = true })
vim.keymap.set("", "<C-L>", "<C-W>l", { silent = true })
vim.keymap.set("n", "J", "mzJ`z", { noremap = true, silent = true })
vim.keymap.set("n", "<C-D>", "<C-D>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-U>", "<C-U>zz", { noremap = true, silent = true })
vim.keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })

-- clear search highlighting
vim.keymap.set("", "<LEADER><CR>", ":noh<CR>", { silent = true })

-- yank/paste/delete mappings
-- yank to OS
vim.keymap.set({"n", "v"}, "y", '"+y', { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, "Y", '"+Y', { noremap = true, silent = true })
-- paste from OS
vim.keymap.set("n", "p", '"+p', { noremap = true, silent = true })
vim.keymap.set("n", "P", '"+P', { noremap = true, silent = true })
-- paste over selection without yanking
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })
-- delete to OS
vim.keymap.set({"n", "v"}, "d", '"+d', { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, "D", '"+D', { noremap = true, silent = true })
-- change to OS
vim.keymap.set({"n", "v"}, "c", '"+c', { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, "C", '"+C', { noremap = true, silent = true })
-- cut to OS
vim.keymap.set({"n", "v"}, "x", '"+x', { noremap = true, silent = true })

-- escape mappings
vim.keymap.set("!", "jk", "<ESC>", { silent = true })
vim.keymap.set("!", "kj", "<ESC>", { silent = true })
vim.keymap.set("!", "JK", "<ESC>", { silent = true })
vim.keymap.set("!", "KJ", "<ESC>", { silent = true })

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
      call feedkeys("10\<C-W>_")
    else
      :exe "bot split"
      :terminal
      :exe "f " termname
      set nobuflisted
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

vim.cmd([[
  function! RemoveQFItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    execute curqfidx + 1 . "cfirst"
    :copen
  endfunction
  :command! RemoveQFItem :call RemoveQFItem()
  autocmd FileType qf map <buffer> dd :RemoveQFItem<CR>
]])

-- terminal mappings
vim.keymap.set("", "<LEADER>;", ":call ToggleTerminal()<CR>", { silent = true })
vim.keymap.set("", "<LEADER>:", ":call ToggleTerminalSize()<CR>", { silent = true })
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "jj", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "JJ", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "kj", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "JK", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "KJ", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "<C-R>", "'<C-\\><C-N>\"'.nr2char(getchar()).'pi'", { noremap = true, silent = true, expr = true })
vim.keymap.set("t", "<C-J>", "<C-\\><C-N><C-W>j", { silent = true })
vim.keymap.set("t", "<C-K>", "<C-\\><C-N><C-W>k", { silent = true })
vim.keymap.set("t", "<C-H>", "<C-\\><C-N><C-W>h", { silent = true })
vim.keymap.set("t", "<C-L>", "<C-\\><C-N><C-W>l", { silent = true })

-- change split sizes
vim.keymap.set("n", "<M-LEFT>", "<C-w>5<")
vim.keymap.set("n", "<M-RIGHT>", "<C-w>5>")
vim.keymap.set("n", "<M-UP>", "<C-w>+")
vim.keymap.set("n", "<M-DOWN>", "<C-w>-")
