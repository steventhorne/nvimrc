-- leader mappings
vim.keymap.set("", "<SPACE>", "<NOP>")
vim.g.mapleader = " "

-- disable Q EX mode
vim.keymap.set("n", "Q", "<NOP>")

-- movement mappings
vim.keymap.set("", "<UP>", "<NOP>")
vim.keymap.set("", "<DOWN>", "<NOP>")
vim.keymap.set("", "<LEFT>", "<NOP>")
vim.keymap.set("", "<RIGHT>", "<NOP>")
vim.keymap.set("", "<C-J>", "<C-W>j")
vim.keymap.set("", "<C-K>", "<C-W>k")
vim.keymap.set("", "<C-H>", "<C-W>h")
vim.keymap.set("", "<C-L>", "<C-W>l")
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })
vim.keymap.set("n", "<C-D>", "<C-D>zz", { noremap = true })
vim.keymap.set("n", "<C-U>", "<C-U>zz", { noremap = true })
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

-- clear search highlighting
vim.keymap.set("", "<LEADER><CR>", ":noh<CR>")

-- yank/paste/delete mappings
-- yank to OS
vim.keymap.set({"n", "v"}, "y", '"+y', { noremap = true })
vim.keymap.set({"n", "v"}, "Y", '"+Y', { noremap = true })
-- paste from OS
vim.keymap.set("n", "p", '"+p', { noremap = true })
vim.keymap.set("n", "P", '"+P', { noremap = true })
-- paste over selection without yanking
vim.keymap.set("v", "p", '"_dP', { noremap = true })
-- delete to OS
vim.keymap.set({"n", "v"}, "d", '"+d', { noremap = true })
vim.keymap.set({"n", "v"}, "D", '"+D', { noremap = true })

-- escape mappings
vim.keymap.set("!", "jk", "<ESC>")
vim.keymap.set("!", "kj", "<ESC>")
vim.keymap.set("!", "JK", "<ESC>")
vim.keymap.set("!", "KJ", "<ESC>")

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
vim.keymap.set("", "<LEADER>;", ":call ToggleTerminal()<CR>")
vim.keymap.set("", "<LEADER>:", ":call ToggleTerminalSize()<CR>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")
vim.keymap.set("t", "jj", "<C-\\><C-N>")
vim.keymap.set("t", "JJ", "<C-\\><C-N>")
vim.keymap.set("t", "jk", "<C-\\><C-N>")
vim.keymap.set("t", "kj", "<C-\\><C-N>")
vim.keymap.set("t", "JK", "<C-\\><C-N>")
vim.keymap.set("t", "KJ", "<C-\\><C-N>")
vim.keymap.set("t", "<C-R>", "'<C-\\><C-N>\"'.nr2char(getchar()).'pi'", { noremap = true, silent = true, expr = true })
vim.keymap.set("t", "<C-J>", "<C-\\><C-N><C-W>j")
vim.keymap.set("t", "<C-K>", "<C-\\><C-N><C-W>k")
vim.keymap.set("t", "<C-H>", "<C-\\><C-N><C-W>h")
vim.keymap.set("t", "<C-L>", "<C-\\><C-N><C-W>l")
