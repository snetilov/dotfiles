-- Markdown specific settings
vim.opt_local.wrap = true -- Wrap text
vim.opt_local.breakindent = true -- Match indent on line break
vim.opt_local.linebreak = true -- Line break on whole word

-- Allow j/k shen navigating wrapped llines
vim.keymap.set("n", "j", 'v:count == 0 ? "gj" : "j"', { buffer = 0, expr = true, silent = true })
vim.keymap.set("n", "k", 'v:count == 0 ? "gk" : "K"', { buffer = 0, expr = true, silent = true })

-- Spell check
vim.opt_local.spelllang = 'en_us'
vim.opt_local.spell = true
