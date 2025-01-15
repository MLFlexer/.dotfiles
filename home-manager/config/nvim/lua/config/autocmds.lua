-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- markdown preview keybind
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_preview"),
  pattern = { "markdown" },
  callback = function()
    vim.keymap.set("n", "<leader>o", "<Plug>MarkdownPreview", { desc = "Markdown preview", buffer = 0 })
  end,
})

vim.filetype.add({ extension = { fut = "futhark" } })
