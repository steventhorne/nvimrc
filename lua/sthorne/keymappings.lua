-- leader mappings
vim.keymap.set("", "<SPACE>", "<NOP>", { silent = true })
vim.g.mapleader = " "

-- disable man keymapping
-- vim.keymap.set("n", "K", "<NOP>", { silent = true })

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

-- -- paste over selection without yanking
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- escape mappings
vim.keymap.set("!", "jk", "<ESC>", { silent = true })
vim.keymap.set("!", "kj", "<ESC>", { silent = true })
vim.keymap.set("!", "JK", "<ESC>", { silent = true })
vim.keymap.set("!", "KJ", "<ESC>", { silent = true })

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

-- move lines up and down with alt-j/k
vim.keymap.set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! ]c]])
  else
    vim.cmd([[m .+1<CR>==]])
  end
end)

vim.keymap.set("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! [c]])
  else
    vim.cmd([[m .-2<CR>==]])
  end
end)
