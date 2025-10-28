require('lze').load {
  {
    "conform.nvim",
    for_cat = 'format',
    -- cmd = { "" },
    -- event = "",
    -- ft = "",
    keys = {
      { "<leader>FF", desc = "[F]ormat [F]ile" },
    },
    -- colorscheme = "",
    after = function (plugin)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- Nix formatting with alejandra
          nix = { "alejandra" },
          
          -- Lua formatting with stylua
          lua = { "stylua" },
          
          -- Python formatting (run isort first, then black)
          python = { "isort", "black" },
          
          -- Go formatting (gofmt is built into go toolchain)
          go = { "gofmt" },
          
          -- Rust formatting
          rust = { "rustfmt" },
          
          -- Shell script formatting
          sh = { "shfmt" },
          bash = { "shfmt" },
          
          -- C/C++ formatting
          c = { "clang-format" },
          cpp = { "clang-format" },
          
          -- JavaScript/TypeScript formatting
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          
          -- JSON, YAML, HTML, CSS, Markdown formatting
          json = { "prettier" },
          yaml = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          markdown = { "prettier" },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>FF", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[F]ormat [F]ile" })
    end,
  },
}
