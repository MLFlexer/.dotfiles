-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

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

map("n", "<Leader>uD", toggle_diagnostics, { desc = "Toggle line [D]iagnostic type" })

map("n", "<Leader>_", ":vs<CR>", { desc = "Vertical split" })
map("n", "<CR>", "ciw", { desc = "Change word" })

-- Yanking text makes the cursor stay at the current position
map("v", "y", "may`a", { desc = "Yank visual selection" })

map({ "n", "v", "o" }, "H", "^", { desc = "Go to start of line" })
map({ "n", "v", "o" }, "L", "$", { desc = "Go to end of line" })

map("n", "p", "p=`]")
map("n", "P", "P=`]")
