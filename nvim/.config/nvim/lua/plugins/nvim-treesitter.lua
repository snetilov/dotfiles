-- Code Tree Support / Syntax Highlighting
return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  -- event = 'VeryLazy',
  dependencies = {
    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function ()
    local ts = require('nvim-treesitter')
    ts.install({ 'lua', 'comment' })

    local function enable(buf, lang)
      if not vim.api.nvim_buf_is_valid(buf) or not pcall(vim.treesitter.start, buf, lang) then
        return
      end
      if vim.treesitter.query.get(lang, 'indents') then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_setup', { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        if vim.treesitter.language.add(lang) then
          enable(args.buf, lang)
        elseif vim.tbl_contains(ts.get_available(), lang) then
          ts.install(lang):await(function()
            vim.schedule(function()
              enable(args.buf, lang)
            end)
          end)
        end
      end,
    })

    require('nvim-treesitter-textobjects').setup({ select = { lookahead = true } })
    local select = require('nvim-treesitter-textobjects.select')
    for key, query in pairs({
      af = '@function.outer',
      ['if'] = '@function.inner',
      ac = '@class.outer',
      ic = '@class.inner',
      aa = '@parameter.outer',
      ia = '@parameter.inner',
    }) do
      vim.keymap.set({ 'x', 'o' }, key, function()
        select.select_textobject(query, 'textobjects')
      end)
    end
  end
}
