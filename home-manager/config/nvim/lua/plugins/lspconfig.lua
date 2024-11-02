return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      futhark_lsp = { mason = false },
    },
    setup = {
      futhark_lsp = function()
        require("lazyvim.util").lsp.on_attach(function(client) end)
      end,
    },
  },
}
