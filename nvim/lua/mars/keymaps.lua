-- Keymaps
-- Global keymaps that aren't plugin-specific

-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Tabs & Buffers (40% Keyboard friendly)
vim.keymap.set('n', 'tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', 'tj', ':tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', 'tk', ':tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', 'H', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', 'L', ':bnext<CR>', { desc = 'Next buffer' })

-- Window Navigation (Space + h/j/k/l)
vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = 'Move to right window' })

-- File Explorer
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Explorer' })

-- Insert mode escape
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Use jk in input mode as Esc' })

-- Command mode shortcut
vim.keymap.set('n', ';', ':', { desc = 'Use ; as colon' })
