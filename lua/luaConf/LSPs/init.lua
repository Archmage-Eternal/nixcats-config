local catUtils = require('nixCatsUtils')
if (catUtils.isNixCats and nixCats('lspDebugMode')) then
  vim.lsp.set_log_level("debug")
end

-- NOTE: This file uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- This is a slightly more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- nixCats gives us the paths, which is faster than searching the rtp!
local old_ft_fallback = require('lze').h.lsp.get_ft_fallback()
require('lze').h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    if not ok then
      ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
    end
    return (ok and cfg or {}).filetypes or {}
  else
    return old_ft_fallback(name)
  end
end)
-- Load all LSP configurations
local lsp_configs = {}

-- Core LSP setup
table.insert(lsp_configs, {
  "nvim-lspconfig",
  for_cat = "general.core",
  on_require = { "lspconfig" },
  -- NOTE: define a function for lsp,
  -- and it will run for all specs with type(plugin.lsp) == table
  -- when their filetype trigger loads them
  lsp = function(plugin)
    vim.lsp.config(plugin.name, plugin.lsp or {})
    vim.lsp.enable(plugin.name)
  end,
  before = function(_)
    vim.lsp.config('*', {
      on_attach = require('luaConf.LSPs.on_attach'),
    })
  end,
})

-- Lazydev for lua development
table.insert(lsp_configs, {
  -- lazydev makes your lsp way better in your config without needing extra lsp configuration.
  "lazydev.nvim",
  for_cat = "neonixdev",
  cmd = { "LazyDev" },
  ft = "lua",
  after = function(_)
    require('lazydev').setup({
      library = {
        { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. '/lua' },
      },
    })
  end,
})

-- Dynamically load individual LSP configurations
local lsp_files = {
  "lua_ls",
  "nixd", 
  "markdown_oxide",
  "gopls",
  -- Add more LSP files here as you create them
}

for _, lsp_file in ipairs(lsp_files) do
  local ok, config = pcall(require, 'luaConf.LSPs.' .. lsp_file)
  if ok and config then
    table.insert(lsp_configs, config)
  end
end

require('lze').load(lsp_configs)
