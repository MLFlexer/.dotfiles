--better inline lsp diagnostics
return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  event = "LspAttach",
  config = function()
    require("lsp_lines").setup()
  end,
}
