-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<Leader>_", ":vs<CR>", { desc = "Vertical split" })
map("n", "<CR>", "ciw", { desc = "Change word" })

-- Yanking text makes the cursor stay at the current position
map("v", "y", "may`a", { desc = "Yank visual selection" })

map({ "n", "v", "o" }, "H", "^", { desc = "Go to start of line" })
map({ "n", "v", "o" }, "L", "$", { desc = "Go to end of line" })

-- Paste with correct indent
map("n", "p", "p=`]")
map("n", "P", "P=`]")

-- function to toggle "normal" diagnostics or lsp-lines diagnostics.
local function toggle_diagnostics()
  local diagnostics_on = require("lsp_lines").toggle()
  if diagnostics_on then
    vim.diagnostic.config({
      virtual_text = { spacing = 4, prefix = "●" },
      virtual_lines = { only_current_line = true },
    })
  else
    vim.diagnostic.config({
      virtual_text = { spacing = 4, prefix = "●" },
    })
  end
end

-- Toggle diagnostics on current line or below
map("n", "<Leader>uD", toggle_diagnostics, { desc = "Toggle line [D]iagnostic type" })

-- Bufferline
local function go_to_tab(tabnr, absolute)
  return function()
    return require("bufferline").go_to(tabnr, absolute)
  end
end

for i = 1, 9 do
  map("n", "<leader><Tab>" .. i, go_to_tab(i, true), { desc = "Tab " .. i })
end
map("n", "<leader><Tab>0", go_to_tab(10, true), { desc = "Tab 10" })
map("n", "<leader><Tab>h", go_to_tab(1, true), { desc = "first tab" })
map("n", "<leader><Tab>l", go_to_tab(-1, true), { desc = "last tab" })
map("n", "<leader><Tab><Tab>", require("bufferline").pick, { desc = "Pick tab" })

-- smart-split
-- moving between splits
map("n", "<C-h>", require("smart-splits").move_cursor_left)
map("n", "<C-j>", require("smart-splits").move_cursor_down)
map("n", "<C-k>", require("smart-splits").move_cursor_up)
map("n", "<C-l>", require("smart-splits").move_cursor_right)
