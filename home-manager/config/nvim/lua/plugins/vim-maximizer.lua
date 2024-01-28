return {
  dir = "~/repos/nvim_plugs/maximizer.nvim/",
  lazy = true,

  init = function()
    require("maximizer.tabs").setup()
  end,

  keys = {
    -- { "<leader>m", ':lua require("maximizer").toggle()<CR>', desc = "[M]aximize toggle", mode = "n", silent = true },
    -- {
    --   "<leader>m",
    --   ':lua require("maximizer.windows").toggle()<CR>',
    --   -- require("maximizer").maximize_with_tab.toggle,
    --   desc = "[M]aximize toggle",
    --   mode = "n",
    --   silent = true,
    -- },
    {
      "<leader>M",
      ':lua require("maximizer").save_view()<CR>',
      desc = "[M]aximize toggle",
      mode = "n",
      silent = true,
    },
  },
}
