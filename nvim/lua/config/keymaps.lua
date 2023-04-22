-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

vim.keymap.set("n", "<Leader>dl", toggle_diagnostics, { desc = "Toggle [l]ine diagnostic type" })

vim.keymap.set("n", "<Leader>dn", vim.diagnostic.goto_next, { desc = "Go to [n]ext diagnostic" })
vim.keymap.set("n", "<Leader>dp", vim.diagnostic.goto_prev, { desc = "Go to [p]rev diagnostic" })
