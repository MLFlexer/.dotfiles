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

-- Paste with correct indent
map("n", "p", "p=`]")
map("n", "P", "P=`]")

-- ChatGPT keybinds
local chatgpt = require("chatgpt")
map({ "n", "v" }, "<leader>aa", chatgpt.openChat, { desc = "Open ChatGPT promt" })
map({ "n", "v" }, "<leader>aA", chatgpt.selectAwesomePrompt, { desc = "Chat with a choosen actor" })
map({ "n", "v" }, "<leader>aE", chatgpt.edit_with_instructions, { desc = "Edit with ChatGPT" })
-- Run commands
map({ "v" }, "<leader>ac", ":'<,'>ChatGPTRun complete_code<CR>", { desc = "Complete code" })
map({ "v" }, "<leader>ae", ":'<,'>ChatGPTRun explain_code<CR>", { desc = "Explain code" })
map({ "v" }, "<leader>ag", ":'<,'>ChatGPTRun grammar_correction<CR>", { desc = "Correct grammar" })
map({ "v" }, "<leader>ak", ":'<,'>ChatGPTRun keywords<CR>", { desc = "Get keywords in text" })
map({ "v" }, "<leader>ad", ":'<,'>ChatGPTRun docstring<CR>", { desc = "Create docstring" })
map({ "v" }, "<leader>at", ":'<,'>ChatGPTRun add_tests<CR>", { desc = "Add tests" })
map({ "v" }, "<leader>ao", ":'<,'>ChatGPTRun optimize_code<CR>", { desc = "Optimize code" })
map({ "v" }, "<leader>as", ":'<,'>ChatGPTRun summarize<CR>", { desc = "Summarize" })
map({ "v" }, "<leader>ab", ":'<,'>ChatGPTRun fix_bugs<CR>", { desc = "Fix bugs" })
map({ "v" }, "<leader>aR", ":'<,'>ChatGPTRun roxygen_edit<CR>", { desc = "Roxygen edit" })
map({ "v" }, "<leader>ar", ":'<,'>ChatGPTRun code_readability_analysis<CR>", { desc = "Analyse code readability" })
