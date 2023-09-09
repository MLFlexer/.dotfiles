-- ability to toggle maximize window
return {
  "szw/vim-maximizer",
  keys = {
    { "<leader>m", ":MaximizerToggle<CR>", desc = "[M]aximize toggle", mode = "n", silent = true },
  },
}
