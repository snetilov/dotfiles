vim.opt.autocomplete = true
vim.opt.complete = "o,."
vim.opt.completeopt = "menu,menuone,noinsert,popup"

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

local function pum_or(key, pum_key)
  vim.keymap.set("i", key, function()
    return vim.fn.pumvisible() == 1 and pum_key or key
  end, { expr = true })
end

pum_or("<C-j>", "<C-n>")
pum_or("<C-k>", "<C-p>")

local function tab(key, pum_key, direction)
  vim.keymap.set({ "i", "s" }, key, function()
    if vim.fn.pumvisible() == 1 then
      return pum_key
    elseif vim.snippet.active({ direction = direction }) then
      return ("<Cmd>lua vim.snippet.jump(%d)<CR>"):format(direction)
    end
    return key
  end, { expr = true })
end

tab("<Tab>", "<C-n>", 1)
tab("<S-Tab>", "<C-p>", -1)

vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return vim.keycode(vim.fn.complete_info({ "selected" }).selected == -1 and "<C-n><C-y>" or "<C-y>")
  end
  return require("nvim-autopairs").autopairs_cr()
end, { expr = true, replace_keycodes = false })

vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get)
