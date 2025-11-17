local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'tokyonight'
end

vim.cmd.colorscheme(colorschemeName)

-- require("luaConf.plugins.notify")  -- Disabled: Testing snacks.notifier
require("luaConf.plugins.snacks-nvim")  -- Direct load for startupPlugin

-- Oil removed - using snacks explorer instead

require('lze').load {
  -- Core plugins (unchanged)
  { import = "luaConf.plugins.telescope", },
  { import = "luaConf.plugins.markview", },
  { import = "luaConf.plugins.zotcite", },
  { import = "luaConf.plugins.treesitter", },
  { import = "luaConf.plugins.completion", },
  { import = "luaConf.plugins.undotree", },
  { import = "luaConf.plugins.vim-startuptime", },
  { import = "luaConf.plugins.hlargs",},
  { import = "luaConf.plugins.lualine", },  -- Re-enabled: statuscolumn is different from statusline
  { import = "luaConf.plugins.gitsigns", },
  
  { import = "luaConf.plugins.comment", },
  -- { import = "luaConf.plugins.indent-blankline", },  -- Disabled: Testing snacks indent
  { import = "luaConf.plugins.nvim-surround", },
  { import = "luaConf.plugins.fidget", },
  { import = "luaConf.plugins.which-key", },
}
