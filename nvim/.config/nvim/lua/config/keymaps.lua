local keymap = vim.keymap

-- General keymaps
keymap.set("n", "<leader>wq", ":wq<CR>") -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>") -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>") -- save

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>ss", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close split window
keymap.set("n", "<leader>sj", "<C-w>-") -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+") -- make split windows height taller
keymap.set("n", "<leader>sl", "5<C-w>>") -- make split windows width bigger 
keymap.set("n", "<leader>sh", "5<C-w><") -- make split windows width smaller
keymap.set("n", "<leader>sm", function() Snacks.zen.zoom() end) -- toggle maximize tab

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- previous tab

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>") -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>") -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>") -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c") -- next diff hunk
keymap.set("n", "<leader>cp", "[c") -- previous diff hunk

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

local mini_files = require("mini.files")

-- Open explorer (like toggle, but simpler)
vim.keymap.set("n", "<leader>ee", function()
  mini_files.open()
end, { desc = "Open mini.files" })

-- "Focus" doesn't really exist, but reopening works similarly
vim.keymap.set("n", "<leader>er", function()
  mini_files.open()
end, { desc = "Open mini.files (focus)" })

-- Reveal current file (closest to NvimTreeFindFile)
vim.keymap.set("n", "<leader>ef", function()
  mini_files.open(vim.api.nvim_buf_get_name(0))
end, { desc = "Reveal current file" })

-- Snacks.picker
local picker = require("snacks.picker")

vim.keymap.set("n", "<leader>ff", function()
  local dir = vim.fn.expand("%:p:h")
  require("snacks.picker").files({
    cwd = dir,
  })
end)
keymap.set('n', '<leader>fg', function() picker.grep() end)
keymap.set('n', '<leader>fb', function() picker.buffers() end)
keymap.set('n', '<leader>fh', function() picker.help() end)
keymap.set('n', '<leader>fs', function() picker.lines() end)
keymap.set('n', '<leader>fo', function() picker.lsp_symbols() end)
keymap.set('n', '<leader>fi', function() picker.lsp_incoming_calls() end)

keymap.set('n', '<leader>fm', function()
  picker.treesitter({ symbols = { "function", "method" } })
end)

keymap.set('n', '<leader>ft', function()
  local success, entry = pcall(mini_files.get_fs_entry)
  if not success or not entry then return end

  mini_files.close()
  picker.grep({
    dirs = { entry.path },
  })
end)

keymap.set('n', '<leader>f', function()
  picker.smart()
end)

-- GitSigns
vim.keymap.set("n", "<leader>gb", function()
  require("gitsigns").blame()
end)

-- LSP
keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')

-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
keymap.set("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>")
keymap.set("n", "<leader>ba", function()
  require("dapui").float_element("breakpoints", { enter = true })
end)
keymap.set("n", "<leader>db", function()
  picker.dap_breakpoints()
end)
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
keymap.set("n", '<leader>dd', function() require('dap').disconnect(); require('dapui').close(); end)
keymap.set("n", '<leader>dt', function() require('dap').terminate(); require('dapui').close(); end)
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap.set("n", '<leader>di', function() require "dap.ui.widgets".hover() end)
keymap.set("n", '<leader>d?', function() local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes) end)
keymap.set("n", "<leader>df", function()
  picker.dap_frames()
end)
keymap.set("n", "<leader>dh", function()
  picker.dap_commands()
end)
keymap.set("n", "<leader>de", function()
  picker.diagnostics({ severity = vim.diagnostic.severity.ERROR })
end)
