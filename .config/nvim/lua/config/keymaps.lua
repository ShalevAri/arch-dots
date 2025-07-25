-- local discipline = require("user.discipline")
local harpoon = require("harpoon")

-- discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>pp", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>pp", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Moving lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Exit Insert Mode
-- keymap.set("i", "jj", "<Esc>")

-- Tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Save/quit files
keymap.set("n", "WW", "<cmd>w<CR>", opts)
keymap.set("n", "QQ", "<cmd>q!<CR>", opts)
keymap.set("n", "WQ", "<cmd>wq!<CR>", opts)
keymap.set("i", "<C-c>", "<Esc>")

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Saving files
-- keymap.set("n", "<leader>w", "<cmd>wq!<CR>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
-- keymap.set("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", "<cmd>tabedit<CR>")
keymap.set("n", "<tab>", "<cmd>bnext<CR>", opts)
keymap.set("n", "<s-tab>", "<cmd>bprevious<CR>", opts)

-- Split window
keymap.set("n", "<leader>sp", "<cmd>vsplit<CR>", opts)
keymap.set("n", "<leader>sv", "<cmd>split<CR>", opts)
keymap.set("n", "<leader>sx", "<cmd>close<CR>", opts)

-- Move window
keymap.set("n", "<leader>sh", "<C-w>h")
keymap.set("n", "<leader>sk", "<C-w>k")
keymap.set("n", "<leader>sj", "<C-w>j")
keymap.set("n", "<leader>sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Undotree
vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })

-- harpoon

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end)

vim.keymap.set("n", "<S-t>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<S-f>", function()
  harpoon:list():select(1)
end)

vim.keymap.set("n", "<S-l>", function()
  harpoon:list():select(2)
end)

vim.keymap.set("n", "<S-e>", function()
  harpoon:list():select(3)
end)

vim.keymap.set("n", "<S-R>", function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end)

-- Diagnostics (disabled for now, to be able to use tmux properly)
-- keymap.set("n", "<C-j>", function()
--   vim.diagnostic.goto_next()
-- end, opts)

keymap.set("n", "<leader>i", function()
  require("user.lsp").toggleInlayHints()
end)
