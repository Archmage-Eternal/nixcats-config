-- Markdown LSP for Obsidian-like experience based on official docs
return {
  "markdown_oxide",
  enabled = nixCats('markdown') or false,
  ft = { "markdown" },
  after = function()
    -- Register markdown_oxide with lspconfig since it's not built-in
    local lspconfig = require('lspconfig')
    local configs = require('lspconfig.configs')

    if not configs.markdown_oxide then
      configs.markdown_oxide = {
        default_config = {
          cmd = { 'markdown-oxide' },
          filetypes = { 'markdown' },
          root_dir = function(fname)
            local util = require('lspconfig.util')
            return util.root_pattern('.git', '.obsidian', '.moxide.toml')(fname) 
              or util.find_git_ancestor(fname) 
              or vim.fn.fnamemodify(fname, ':h')
          end,
          single_file_support = true,
        },
      }
    end

    -- Setup with proper capabilities for dynamicRegistration
    lspconfig.markdown_oxide.setup({
      capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        }
      ),
      on_attach = function(client, bufnr)
        -- Apply standard on_attach
        require('luaConf.LSPs.on_attach')(client, bufnr)

        -- Custom hover handler for better markdown rendering
        vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
          config = config or {}
          config.border = config.border or 'rounded'
          config.max_width = config.max_width or 80
          config.max_height = config.max_height or 20

          if not (result and result.contents) then
            return
          end

          -- Let the default handler process the hover
          return vim.lsp.handlers.hover(_, result, ctx, config)
        end
      end,
    })
  end,
}
