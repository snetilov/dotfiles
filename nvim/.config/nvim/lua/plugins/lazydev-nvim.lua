-- Lua LSP configuration for Neovim config/plugin development
return {
  -- https://github.com/folke/lazydev.nvim
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  opts = {
    libarry = {
      -- Load luvit types when the 'vim.uv' word is foound
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
