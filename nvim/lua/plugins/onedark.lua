return {
  -- add onedarker
  { "lunarvim/Onedarker.nvim" },

  -- Configure LazyVim to load onedarker
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedarker",
    },
  },
}
