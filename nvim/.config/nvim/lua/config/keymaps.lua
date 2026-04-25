-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

-- General keymaps
keymap.set("n", "<leader>wq", ":wq<CR>") -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>") -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>") -- save
keymap.set("n", "gx", function()
  local url = vim.fn.expand("<cfile>")
  if url == "" then
    return
  end

  if vim.ui.open then
    vim.ui.open(url)
    return
  end

  local open_cmd = "xdg-open"
  if vim.fn.has("mac") == 1 then
    open_cmd = "open"
  elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    open_cmd = "explorer.exe"
  end

  vim.fn.jobstart({ open_cmd, url }, { detach = true})
end) -- open URL under function 

-- Navigate vim panes better
keymap.set('n', '<c-k>', ':wincmd k<CR>')
keymap.set('n', '<c-j>', ':wincmd j<CR>')
keymap.set('n', '<c-h>', ':wincmd h<CR>')
keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Vim-tmux-navigator
keymap.set('n', 'C-h', ':TmuxNavigateLeft<CR>')
keymap.set('n', 'C-j', ':TmuxNavigateDown<CR>')
keymap.set('n', 'C-k', ':TmuxNavigateUp<CR>')
keymap.set('n', 'C-l', ':TmuxNavigateRight<CR>')

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close split window
keymap.set("n", "<leader>sj", "<C-w>-") -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+") -- make split windows height taller
keymap.set("n", "<leader>sl", "<C-w>>5") -- make split windows width bigger 
keymap.set("n", "<leader>sh", "<C-w><5") -- make split windows width smaller

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

-- Windows.nvim
keymap.set("n", "<leader>sm", "<cmd>WindowsMaximize<CR>") -- toggle maximize tab

-- Nvim-tree
-- keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>") -- toggle file explorer
-- keymap.set("n", "<leader>er", ":NvimTreeFocus<CR>") -- toggle focus to file explorer
-- keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>") -- find file in file explorer
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
local keymap = vim.keymap

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
  local success, node = pcall(function()
    return require('nvim-tree.lib').get_node_at_cursor()
  end)
  if not success or not node then return end

  picker.grep({
    dirs = { node.absolute_path },
  })
end)

keymap.set('n', '<leader>f', function()
  picker.smart()
end)

-- GitSigns
vim.keymap.set("n", "<leader>gb", function()
  require("gitsigns").blame()
end)

-- Vim REST Console
keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>") -- Run REST query

-- LSP
keymap.set('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>')
keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')
keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
keymap.set('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>')
keymap.set('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
keymap.set('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
keymap.set('n', '<leader>tr', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>')

-- Filetype-specific keymaps (these can be done in the ftplugin directory instead if you prefer)
keymap.set("n", '<leader>go', function()
  if vim.bo.filetype == 'java' then
    require('jdtls').organize_imports();
  end
end)

keymap.set("n", '<leader>gu', function()
  if vim.bo.filetype == 'java' then
    require('jdtls').update_projects_config();
  end
end)

keymap.set("n", '<leader>tc', function()
  if vim.bo.filetype == 'java' then
    require('jdtls').test_class();
  end
end)

keymap.set("n", '<leader>tm', function()
  if vim.bo.filetype == 'java' then
    require('jdtls').test_nearest_method();
  end
end)

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
  picker.diagnostics({ pattern = ":E:" })
end)
