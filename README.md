# Personal Neovim Configuration with nixCats

This is a personal Neovim configuration built using [nixCats](https://github.com/BirdeeHub/nixCats-nvim), a nix-based Neovim configuration framework. The setup emphasizes plugin consolidation using [snacks.nvim](https://github.com/folke/snacks.nvim) as a mega-plugin to replace multiple individual plugins, while maintaining a clean and performant editing environment.

## Why nixCats?

nixCats provides several advantages over traditional plugin managers:

**Transparency**: Uses normal packpath loading methods instead of hijacking plugin mechanisms, making it clear what happens during startup and plugin loading.

**Reproducibility**: Nix ensures consistent plugin versions and dependencies across different systems and installations.

**Flexibility**: Supports both lazy and startup loading without conflicting with Neovim's native plugin system.

**Compatibility**: Maintains fallback support for non-nix environments while avoiding duplication between nix and other download managers.

## Architecture

This configuration leverages [lze](https://github.com/BirdeeHub/lze) for lazy loading and follows a modular structure across multiple files rather than a monolithic approach. The setup is organized using nixCats' category system to conditionally load features.

## Plugins

### Framework
- `lze` - Lazy loading
- `snacks.nvim` - File explorer, notifications, word highlighting, indent guides, terminal
- `plenary.nvim` - Lua utilities

### Editing
- `telescope.nvim` - Fuzzy finder
- `undotree` - Undo history
- `comment.nvim` - Code commenting  
- `nvim-surround` - Surround text objects
- `vim-sleuth` - Auto indentation

### Completion & LSP
- `nvim-lspconfig` - LSP configurations
- `blink.cmp` - Completion engine
- `luasnip` - Snippets
- `colorful-menu.nvim` - Completion menu colors

### Syntax
- `nvim-treesitter` - Syntax highlighting
- `hlargs.nvim` - Function argument highlighting
- `markview.nvim` - Markdown preview

### Git
- `gitsigns.nvim` - Git signs and blame
- `vim-fugitive` - Git commands
- `vim-rhubarb` - GitHub integration

### Code Quality
- `conform.nvim` - Formatting
- `nvim-lint` - Linting

### Debugging
- `nvim-dap` - Debug adapter
- `nvim-dap-ui` - Debug interface
- `nvim-dap-python` - Python debugging
- `nvim-dap-go` - Go debugging

### UI
- `lualine.nvim` - Status line
- `fidget.nvim` - LSP progress
- `which-key.nvim` - Keybinding help
- `nvim-web-devicons` - File icons

### Language Support
- `lazydev.nvim` - Lua development
- `rust-tools.nvim` - Rust tools

### Language Support

**Markdown**: Enhanced with `markdown-oxide` LSP server and specialized rendering
**Lua**: Configured with `lua_ls` for Neovim development
**Nix**: Integrated with `nixd` language server for configuration management
**Go**: Supported via `gopls` language server

### Formatters

- `stylua` - Lua code formatting
- `alejandra` - Nix expression formatting
- `prettier` - Multi-language formatting for web technologies

## Credits

This configuration is built upon the foundation provided by [BirdeeHub](https://github.com/BirdeeHub), the creator of both [nixCats](https://github.com/BirdeeHub/nixCats-nvim) and [lze](https://github.com/BirdeeHub/lze). Their work has made it possible to create a transparent, nix-native Neovim configuration that avoids the complexity and opacity of traditional plugin managers (yet I still don't really get it).
