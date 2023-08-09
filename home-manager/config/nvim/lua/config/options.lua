-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.scrolloff = 0
opt.wrap = true -- enable text wrapping

vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●" },
  -- Works after fix in neovim v9.0
  virtual_lines = { only_current_line = true },
})
