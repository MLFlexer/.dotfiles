return {
  dir = "~/repos/nvim_plugs/aiui.nvim/",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  init = function()
    --adds default keybindings and initializes
    require("aiui").add_defaults()

    -- If NOT using the default setup:
    -- adds Ollama
    -- local ModelCollection = require("aiui.ModelCollection")
    -- local ollama_client = require("models.clients.ollama.ollama_curl")
    -- ModelCollection:add_models(ollama_client:get_default_models())

    -- Add any agents you like
    -- ModelCollection:add_agents({
    -- 	default_agent = "You are a chatbot, answer short and concise.",
    -- })

    -- Initialize the Chat and set default keybinds and autocmds
    -- local Chat = require("aiui.Chat")
    -- Chat:new({
    --   name = "Mistral Tiny",
    --   model = "mistral-tiny",
    --   context = {},
    --   agent = "default_agent",
    -- })
    -- Chat:apply_default_keymaps()
    -- Chat:apply_autocmd()
  end,
}
