return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
  },
  keys = {
    { mode = { "n" }, "<leader>cn", ':lua require("nvim-navbuddy").open()<CR>', desc = "Open navbuddy", silent = true },
  },
}
