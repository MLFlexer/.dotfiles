return {
  {
    "neovim/nvim-lspconfig",
    --turn of the default inline diagnostic to remove redundency from lsp-lines.
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },
}
