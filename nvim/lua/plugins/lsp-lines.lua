vim.diagnostic.config({
  virtual_text = false,
})

--better inline lsp diagnostics
return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()
  end,
}