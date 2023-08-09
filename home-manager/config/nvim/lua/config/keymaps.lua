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

-- maximize window
map("n", "<leader>wm", ":MaximizerToggle<CR>", { desc = "[W]indow [M]aximize toggle" })

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

-- Telescope undo
map("n", "<leader>fu", require("telescope").extensions.undo.undo, { desc = "Undo tree" })

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

-- Codeium keybinds
local function vim_fn(vim_cmd, args)
  return function()
    return vim.fn[vim_cmd](args)
  end
end

map("i", "<C-l>", vim.fn["codeium#Accept"], { desc = "Accept Codeium", expr = true })
map("i", "<C-j>", vim_fn("codeium#CycleCompletions", 1), { desc = "Cycle completions", expr = true })
map("i", "<C-k>", vim_fn("codeium#CycleCompletions", -1), { desc = "Cycle completions back", expr = true })
map("i", "<C-x>", vim.fn["codeium#Clear"], { desc = "Clear Codeium", expr = true })

-- nvim-navbuddy
map("n", "<leader>cn", require("nvim-navbuddy").open, { desc = "Open navbuddy" })

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
