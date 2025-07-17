local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'tokyonight'
end

vim.cmd.colorscheme(colorschemeName)

require("luaConf.plugins.notify")

if nixCats('general.extra') then
        require("luaConf.plugins.oil")
end

require('lze').load {
  { import = "luaConf.plugins.telescope", },
  { import = "luaConf.plugins.markview", },
  { import = "luaConf.plugins.treesitter", },
  { import = "luaConf.plugins.completion", },
  { import = "luaConf.plugins.undotree", },
  { import = "luaConf.plugins.comment", },
  { import = "luaConf.plugins.indent-blankline", },
  { import = "luaConf.plugins.nvim-surround", },
  { import = "luaConf.plugins.vim-startuptime", },
  { import = "luaConf.plugins.fidget", },
  { import = "luaConf.plugins.hlargs",},
  { import = "luaConf.plugins.lualine", },
  { import = "luaConf.plugins.gitsigns", },
  { import = "luaConf.plugins.which-key", },
}
