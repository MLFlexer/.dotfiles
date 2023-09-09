local function vim_fn(vim_cmd, args)
  return function()
    return vim.fn[vim_cmd](args)
  end
end

return {
  -- "Exafunction/codeium.vim",
  -- keys = {
  --   { mode = { "i" }, "<C-l>", vim.fn["codeium#Accept"], desc = "Accept Codeium", expr = true , silent = true },
  --   { mode = { "i" }, "<C-j>", vim_fn("codeium#CycleCompletions", 1), desc = "Cycle completions", expr = true , silent = true },
  --   { mode = { "i" }, "<C-k>", vim_fn("codeium#CycleCompletions", -1), desc = "Cycle completions back", expr = true , silent = true },
  --   { mode = { "i" }, "<C-x>", vim.fn["codeium#Clear"], desc = "Clear Codeium", expr = true , silent = true },
  -- },
}
