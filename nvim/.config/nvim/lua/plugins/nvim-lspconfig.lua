-- LSP Support
return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    -- LSP Management
    -- https://github.com/williamboman/mason.nvim
    { 'williamboman/mason.nvim' },

    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function ()
    require('mason').setup()

    require('mason-tool-installer').setup({
      -- Install these linters, formatters, debuggers automatically
      ensure_installed = {
        'bash-language-server', -- requires npm to be installed
        'css-lsp', -- requires npm to be installed
        'html-lsp', -- requires npm to be installed
        'gradle-language-server',
        'groovy-language-server',
        'lua-language-server',
        'jdtls',
        'json-lsp', -- requires npm to be installed
        'lemminx',
        'marksman',
        'quick-lint-js',
        -- 'typescript-language-server', -- requires npm to be installed
        'yaml-language-server', -- requires npm to be installed
        'java-debug-adapter',
        'java-test',
      },
    })

    -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
    vim.api.nvim_command('MasonToolsInstall')

    vim.lsp.enable({
      'bashls',
      'cssls',
      'html',
      'gradle_ls',
      'groovyls',
      'lua_ls',
      'jsonls',
      'lemminx',
      'marksman',
      'quick_lint_js',
      'yamlls',
    })

    -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
    local open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded" -- Set border to rounded
      return open_floating_preview(contents, syntax, opts, ...)
    end

  end
}

