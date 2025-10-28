-- LTeX Language Server configuration for grammar and spell checking
return {
  "ltex",
  enabled = nixCats('spellcheck') or false,
  lsp = {
    filetypes = { 
      "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd", "context", "html", "xhtml" 
    },
    settings = {
      ltex = {
        -- Language for spell/grammar checking
        language = "en-US",
        
        -- Grammar and spell check settings
        checkFrequency = "edit",  -- Check on every edit
        clearDiagnosticsWhenClosingFile = true,
        
        -- Diagnostic severity (helps distinguish from other LSPs)
        diagnosticSeverity = "information",  -- Can be "error", "warning", "information", or "hint"
        
        -- Dictionary settings
        dictionary = {
          -- Add custom words here that shouldn't be flagged as errors
          ["en-US"] = {
            "nixCats", "nixos", "neovim", "lua", "treesitter", "lsp", "snacks", "markview"
          }
        },
        
        -- Disable specific rules if needed
        disabledRules = {
          ["en-US"] = {
            -- "WHITESPACE_RULE"  -- Example: disable whitespace checking
          }
        },
        
        -- Additional languages can be enabled
        -- additionalRules = {
        --   motherTongue = "en-US",
        --   enablePickyRules = true,
        -- },
        
        -- Java path (usually auto-detected)
        -- java = {
        --   path = "/usr/bin/java"  -- Adjust if needed
        -- },
      },
    },
  },
}