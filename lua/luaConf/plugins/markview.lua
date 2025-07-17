-- luaConf/plugins/markview.lua
return {
  {
    "OXY2DEV/markview.nvim",
    for_cat = "general.markdown",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("markview").setup({
        experimental = {
          date_formats = {},
          date_time_formats = {},
          text_filetypes = {},
          read_chunk_size = 1000,
          link_open_alerts = false,
          prefer_nvim = true,
          file_open_command = "tabnew",
          list_empty_line_tolerance = 3,
        },
        highlight_groups = {},
        preview = {
          enable = true,
          filetypes = { "md", "rmd", "quarto" },
          ignore_buftypes = { "nofile" },
          ignore_previews = {},
          modes = { "n", "no", "c" },
          hybrid_modes = {},
          debounce = 50,
          draw_range = { vim.o.lines, vim.o.lines },
          edit_range = { 1, 0 },
          callbacks = {},
          splitview_winopts = { split = "left" },
	  icon_provider = "devicons", -- "mini" or "internal"
        },
        renderers = {},
        html = { enable = true, container_elements = {}, headings = {}, void_elements = {} },
        latex = { enable = true },
        markdown = { enable = true },
        markdown_inline = { enable = true },
        typst = { enable = true },
        yaml = { enable = true },
      })
    end,
  },
}

