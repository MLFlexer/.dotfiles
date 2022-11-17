local status, _ = pcall(vim.cmd, "colorscheme onedarker")
if not status then
    print("colorscheme not found")
    return
end
