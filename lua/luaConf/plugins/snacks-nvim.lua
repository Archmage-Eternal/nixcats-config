-- Simple snacks.nvim setup
require("snacks").setup({
  -- Core modules that are working well
  bigfile = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  explorer = { enabled = true },
  words = { enabled = true },
  indent = { enabled = true },
  statuscolumn = { enabled = true },
  
  -- Additional useful modules
  lazygit = { enabled = true },    -- Integrated git interface
  scratch = { enabled = true },    -- Quick scratch buffers
  terminal = { enabled = true },   -- Enhanced terminal
  toggle = { enabled = true },     -- Quick setting toggles
  bufdelete = { enabled = true },  -- Better buffer deletion
  
  -- Keep these disabled for now
  dashboard = { enabled = false },
  input = { enabled = false },
  win = { enabled = false },
  zen = { enabled = false },
})
      
-- Keybinding for snacks explorer
vim.keymap.set("n", "<leader>e", function() require("snacks").explorer() end, { desc = "Open Snacks Explorer" })

-- Create Snacks command
vim.api.nvim_create_user_command("Snacks", function(opts)
  local snacks = require("snacks")
  local cmd = opts.fargs[1]
  if cmd and snacks[cmd] then
    snacks[cmd]()
  else
    print("Available snacks: explorer, notifier, words, etc.")
  end
end, { nargs = "*", complete = function()
  return { "explorer", "notifier", "words", "indent" }
end })

-- Set up better highlight groups for word highlighting
vim.api.nvim_set_hl(0, "SnacksWords", { bg = "#3e4451", underline = true })
vim.api.nvim_set_hl(0, "SnacksWordsCurrent", { bg = "#e06c75", fg = "#ffffff", bold = true })