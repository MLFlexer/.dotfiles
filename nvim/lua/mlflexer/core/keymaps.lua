vim.g.mapleader = " "

local keymap = vim.keymap

--general keymaps
--keymap.set("i", "jk", "<ESC>") --Escape with jk
--move in insert mode with Ctrl+hjkl
keymap.set("i", "<C-h>", "<Left>")
keymap.set("i", "<C-j>", "<Down>")
keymap.set("i", "<C-k>", "<Up>")
keymap.set("i", "<C-l>", "<Right>")

keymap.set("n", "<leader>nh", ":nohl<CR>") --removes highlighting when search highlighting is on.

keymap.set("n", "x", '"_x') -- does not copy the deleted char to reg

keymap.set("n", "<leader>|", "<C-w>v") --split window vertically with "|"
keymap.set("n", "<leader>-", "<C-w>s") --split window horizontally with "-"
keymap.set("n", "<leader>x", ":close<CR>") -- close current window

keymap.set("n", "<leader>c", ":tabnew<CR>") --open new tab
--next tab is really slow
keymap.set("n", "<leader>n", ":tabn<CR>") --go to next tab
keymap.set("n", "<leader>p", ":tabp<CR>") --go to prev tab

-- plugin keymaps
keymap.set("n", "<leader>m", ":MaximizerToggle<CR>") --maximize/minimize current window with space+m
--nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") --toggle file tree

--telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
