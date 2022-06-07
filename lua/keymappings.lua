local map_key = require('utils').map_key

map_key('n', '<space>', '<nop>')
vim.g.mapleader = ' '

map_key('', '<up>', '<nop>')
map_key('', '<down>', '<nop>')
map_key('', '<left>', '<nop>')
map_key('', '<right>', '<nop>')
map_key('i', 'jj', '<ESC>')
map_key('i', 'JJ', '<ESC>')
map_key('n', '<leader>w', ':w!<CR>')
map_key('', '<c-space>', '?')
map_key('', '<leader><cr>', ':noh<cr>')
map_key('', '<C-j>', '<C-W>j')
map_key('', '<C-k>', '<C-W>k')
map_key('', '<C-h>', '<C-W>h')
map_key('', '<C-l>', '<C-W>l')

