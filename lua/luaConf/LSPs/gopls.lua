-- Go Language Server configuration
return {
  "gopls",
  enabled = nixCats('go') or false,
  lsp = {
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
      gopls = {
        -- You can add gopls-specific settings here when you start learning Go
        -- Common ones include:
        -- analyses = {
        --   unusedparams = true,
        -- },
        -- staticcheck = true,
        -- gofumpt = true,
      },
    },
  },
}