return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
  },
  config = function()
    require("telescope").setup({
      extensions = {
        undo = {},
      },
    })
    require("telescope").load_extension("undo")
  end,
  keys = {
    {
      mode = { "n" },
      "<leader>fu",
      ':lua require("telescope").extensions.undo.undo()<CR>',
      desc = "Undo tree",
      silent = true,
    },
  },
}
