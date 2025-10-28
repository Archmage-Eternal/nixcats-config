
require("luaConf.opts_and_keys")

-- NOTE: register an extra lze handler with the spec_field "for_cat"
-- that makes enabling an lze spec for a category slightly nicer
require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)

-- NOTE: Register another one from lzextras. This one makes it so that
-- you can set up lsps within lze specs,
-- and trigger lspconfig setup hooks only on the correct filetypes
require("lze").register_handlers(require("lzextras").lsp)

require("luaConf.plugins")

require("luaConf.LSPs")

local function require_if_cat(category, module_path)
	if nixCats(category) then
		require(module_path)
	end
end

require_if_cat("debug", "luaConf.debug")
require_if_cat("lint", "luaConf.lint")
require_if_cat("format", "luaConf.format")

-- Set up spell checking if enabled
if nixCats("spellcheck") then
	local spell = require("luaConf.spell")
	spell.setup_native_spell()
	spell.setup_spell_highlights()
end

