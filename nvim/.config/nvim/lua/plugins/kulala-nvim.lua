-- kulala.nvim
return {
  {
    "mistweaverco/kulala.nvim",
    tag = "v5.3.4",
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
    },
  },
}
