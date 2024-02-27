return {

  "neovim/nvim-lspconfig",
  opts = { ---@type lspconfig.options
    servers = {
      nixd = {},
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            lens = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
    },
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
      -- example to setup with typescript.nvim
      -- tsserver = function(_, opts)
      --   require("typescript").setup({ server = opts })
      --   return true
      -- end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,},
    },
    -- format = {
    --   formatting_options = {
    --     filter = function(client)
    --       return client.name ~= "erlangls"
    --     end,
    --   },
    -- },
  },
}
