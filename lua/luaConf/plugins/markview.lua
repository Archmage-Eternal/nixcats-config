return {
  {
    "markview.nvim",
    for_cat = "markdown", 
    lazy = false,
    priority = 60,
    config = function()
      require("markview").setup({
        preview = {
          enable = true,
          filetypes = { "markdown", "md", "rmd", "quarto" },
          icon_provider = "devicons",
        },
        markdown = { enable = true },
        markdown_inline = { enable = true },
        latex = { enable = true }, 
        yaml = { enable = true }, 
        html = { enable = true },
      })
    end,
  },
}

