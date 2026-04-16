-- Snacks.nvim
return {
  -- https://github.com/folke/snacks.nvim
  "folke/snacks.nvim",
  opts = {
    bigfile = { enabled = true},
    indent = { enabled = true, scope = { enabled = false }, animate = { enabled = false } }, 
    notifier = { enabled = true },
    picker = { enabled = true}
  },
}
