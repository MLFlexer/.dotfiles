--keybind to pick buffer
return {
  "akinsho/bufferline.nvim",
  keys = { {
    "<leader><Tab>p",
    "<Cmd>BufferLinePick<CR>",
    desc = "[B]ufferline [P]ick",
  } },
}
