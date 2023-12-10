local home = vim.fn.expand("$HOME")

return {
  "jackMort/ChatGPT.nvim",
  lazy = true,
  config = function()
    require("chatgpt").setup({
      api_key_cmd = "gpg --decrypt " .. home .. "/.secrets/open_ai.txt.gpg",
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      mode = { "n", "v" },
      "<leader>aa",
      ':lua require("chatgpt").openChat',
      desc = "Open ChatGPT promt",
      silent = true,
    },
    {
      mode = { "n", "v" },
      "<leader>aA",
      ':lua require("chatgpt").selectAwesomePrompt',
      desc = "Chat with a choosen actor",
      silent = true,
    },
    {
      mode = { "n", "v" },
      "<leader>aE",
      ':lua require("chatgpt").edit_with_instructions',
      desc = "Edit with ChatGPT",
      silent = true,
    },
    -- run commands
    { mode = { "v" }, "<leader>ac", ":'<,'>ChatGPTRun complete_code<CR>", desc = "Complete code", silent = true },
    { mode = { "v" }, "<leader>ae", ":'<,'>ChatGPTRun explain_code<CR>", desc = "Explain code", silent = true },
    {
      mode = { "v" },
      "<leader>ag",
      ":'<,'>ChatGPTRun grammar_correction<CR>",
      desc = "Correct grammar",
      silent = true,
    },
    { mode = { "v" }, "<leader>ak", ":'<,'>ChatGPTRun keywords<CR>", desc = "Get keywords in text", silent = true },
    { mode = { "v" }, "<leader>ad", ":'<,'>ChatGPTRun docstring<CR>", desc = "Create docstring", silent = true },
    { mode = { "v" }, "<leader>at", ":'<,'>ChatGPTRun add_tests<CR>", desc = "Add tests", silent = true },
    { mode = { "v" }, "<leader>ao", ":'<,'>ChatGPTRun optimize_code<CR>", desc = "Optimize code", silent = true },
    { mode = { "v" }, "<leader>as", ":'<,'>ChatGPTRun summarize<CR>", desc = "Summarize", silent = true },
    { mode = { "v" }, "<leader>ab", ":'<,'>ChatGPTRun fix_bugs<CR>", desc = "Fix bugs", silent = true },
    { mode = { "v" }, "<leader>aR", ":'<,'>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen edit", silent = true },
    {
      mode = { "v" },
      "<leader>ar",
      ":'<,'>ChatGPTRun code_readability_analysis<CR>",
      desc = "Analyse code readability",
      silent = true,
    },
  },
}
