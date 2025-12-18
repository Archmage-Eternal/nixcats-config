-- Python LSP configuration using basedpyright
-- basedpyright is a community fork of pyright with additional features

return {
  {
    "basedpyright",
    for_cat = "python",
    type = "lsp",
    ft = "python",
    lsp = {
      cmd = { "basedpyright-langserver", "--stdio" },
      root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
      },
      settings = {
        basedpyright = {
          analysis = {
            -- Use ruff for import sorting and formatting
            -- basedpyright focuses on type checking
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "basic", -- basic, standard, strict
          },
        },
      },
    },
  },
}
