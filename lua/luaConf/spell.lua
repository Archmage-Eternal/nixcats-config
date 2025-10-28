-- Spell checking utilities and native Neovim spell support
-- 
-- Dictionary Management Explanation:
-- - zg: Add word to personal dictionary (won't be flagged as misspelled)
-- - zw: Mark word as "bad" (will ALWAYS be flagged, even if it's a real word)
--       Useful for catching personal mistakes like typing "teh" instead of "the"
-- - zug: Undo adding word to dictionary
-- - zuw: Undo marking word as bad

local M = {}

-- Toggle between LTeX and native spell checking (exclusive)
M.toggle_spell_mode = function()
  local current_spell = vim.opt.spell:get()
  local ltex_clients = vim.lsp.get_clients({ bufnr = 0, name = "ltex" })
  
  if #ltex_clients > 0 then
    -- LTeX is active, switch to native
    for _, client in ipairs(ltex_clients) do
      client.stop()
    end
    vim.opt.spell = true
    vim.notify("Switched to native spell checking", vim.log.levels.INFO)
  else
    -- Switch to LTeX and disable native
    vim.opt.spell = false
    vim.cmd("LspStart ltex")
    vim.notify("Switched to LTeX grammar/spell checking", vim.log.levels.INFO)
  end
end

-- Toggle native Neovim spell checking only
M.toggle_native_spell = function()
  vim.opt.spell = not vim.opt.spell:get()
  local status = vim.opt.spell:get() and "enabled" or "disabled"
  vim.notify("Native spell checking " .. status, vim.log.levels.INFO)
end

-- Toggle LTeX Language Server only
M.toggle_ltex = function()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "ltex" })
  if #clients > 0 then
    -- Stop LTeX
    for _, client in ipairs(clients) do
      client.stop()
    end
    vim.notify("LTeX grammar/spell checking disabled", vim.log.levels.INFO)
  else
    -- Start LTeX
    vim.cmd("LspStart ltex")
    vim.notify("LTeX grammar/spell checking enabled", vim.log.levels.INFO)
  end
end

-- Set up spell checking with reasonable defaults
M.setup_native_spell = function()
  -- Set spell language and spellfile location
  vim.opt.spelllang = "en_us"
  
  -- Set up spellfile for custom words (fixes E764 error)
  local spelldir = vim.fn.stdpath("config") .. "/spell"
  vim.fn.mkdir(spelldir, "p")
  vim.opt.spellfile = spelldir .. "/en.utf-8.add"
  
  -- Enable spell checking for specific filetypes, but start with LTeX instead
  local spell_filetypes = { "markdown", "text", "gitcommit", "tex", "rst" }
  
  vim.api.nvim_create_autocmd("FileType", {
    pattern = spell_filetypes,
    callback = function()
      if nixCats('spellcheck') then
        -- Start with LTeX by default, not native spell checking
        vim.opt_local.spell = false  -- Native disabled by default
        -- LTeX will auto-start via LSP configuration
      end
    end,
  })
  
  -- Keybindings for spell checking
  vim.keymap.set('n', '<leader>ts', M.toggle_spell_mode, { desc = '[T]oggle [S]pell mode (LTeX ↔ Native)' })
  vim.keymap.set('n', '<leader>tn', M.toggle_native_spell, { desc = '[T]oggle [N]ative spell only' })
  vim.keymap.set('n', '<leader>tS', M.toggle_ltex, { desc = '[T]oggle LTe[X] spell/grammar' })
  
  -- Spell checking navigation (only works with native spell enabled)
  vim.keymap.set('n', ']s', function()
    if vim.opt.spell:get() then
      vim.cmd('normal! ]s')
    else
      vim.notify("Native spell checking not enabled. Use <leader>tn to enable.", vim.log.levels.WARN)
    end
  end, { desc = 'Next misspelled word (native only)' })
  
  vim.keymap.set('n', '[s', function()
    if vim.opt.spell:get() then
      vim.cmd('normal! [s')
    else
      vim.notify("Native spell checking not enabled. Use <leader>tn to enable.", vim.log.levels.WARN)
    end
  end, { desc = 'Previous misspelled word (native only)' })
  
  -- Spell correction - prioritize LSP code actions if available
  vim.keymap.set('n', 'z=', function()
    -- Fix deprecation warning: use vim.lsp.get_clients instead of get_active_clients
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "ltex" })
    
    if #clients > 0 then
      vim.lsp.buf.code_action()
    else
      -- Use native spell suggestions (only works if native spell is enabled)
      if vim.opt.spell:get() then
        vim.cmd('normal! z=')
      else
        vim.notify("Enable native spell checking first with <leader>tn", vim.log.levels.WARN)
      end
    end
  end, { desc = 'Suggest spell corrections' })
  
  -- Dictionary management (only works with native spell)
  vim.keymap.set('n', 'zg', function()
    if vim.opt.spell:get() then
      vim.cmd('normal! zg')
      vim.notify("Word added to personal dictionary", vim.log.levels.INFO)
    else
      vim.notify("Native spell checking not enabled. Use <leader>tn to enable.", vim.log.levels.WARN)
    end
  end, { desc = 'Add word to personal dictionary' })
  
  vim.keymap.set('n', 'zw', function()
    if vim.opt.spell:get() then
      vim.cmd('normal! zw')
      vim.notify("Word marked as bad (will always be flagged)", vim.log.levels.INFO)
    else
      vim.notify("Native spell checking not enabled. Use <leader>tn to enable.", vim.log.levels.WARN)
    end
  end, { desc = 'Mark word as bad (opposite of zg)' })
  
  vim.keymap.set('n', 'zug', function()
    if vim.opt.spell:get() then
      vim.cmd('normal! zug')
      vim.notify("Removed word from personal dictionary", vim.log.levels.INFO)
    else
      vim.notify("Native spell checking not enabled. Use <leader>tn to enable.", vim.log.levels.WARN)
    end
  end, { desc = 'Undo add to dictionary' })
end

-- Custom highlighting for spell errors
M.setup_spell_highlights = function()
  -- Native Neovim spell checking (more prominent red)
  vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#ff4444" })
  vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#ffaa00" })
  vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#00aa00" })
  vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#aa00aa" })
  
  -- LSP diagnostics (LTeX) - more subtle
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#4a90a4" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#4a90a4" })
end

return M