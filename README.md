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
- `lzextras` - lze extensions
- `snacks.nvim` - File explorer, notifications, word highlighting, indent guides, terminal
- `plenary.nvim` - Lua utilities
- `nvim-nio` - Async I/O library
- `vim-repeat` - Repeat plugin commands
- `nui-nvim` - UI component library (dependency for neogit)

### Editing
- `telescope.nvim` - Fuzzy finder
- `telescope-fzf-native.nvim` - FZF sorter for telescope
- `telescope-ui-select.nvim` - Telescope as UI select
- `undotree` - Undo history
- `comment.nvim` - Code commenting  
- `nvim-surround` - Surround text objects
- `vim-sleuth` - Auto indentation

### Completion & LSP
- `nvim-lspconfig` - LSP configurations
- `blink.cmp` - Completion engine
- `blink-compat` - Compatibility layer for blink.cmp
- `luasnip` - Snippets
- `cmp-cmdline` - Command line completion
- `colorful-menu.nvim` - Completion menu colors

### Syntax
- `nvim-treesitter` - Syntax highlighting (with all grammars)
- `nvim-treesitter-textobjects` - Treesitter textobject selection
- `hlargs.nvim` - Function argument highlighting
- `markview.nvim` - Markdown preview

### Git
- `gitsigns.nvim` - Git signs and blame
- `neogit` - Magit-like Git interface
- `vim-rhubarb` - GitHub integration

### Code Quality
- `conform.nvim` - Formatting
- `nvim-lint` - Linting

### Debugging
- `nvim-dap` - Debug adapter
- `nvim-dap-ui` - Debug interface
- `nvim-dap-virtual-text` - Virtual text for DAP
- `nvim-dap-python` - Python debugging
- `nvim-dap-go` - Go debugging

### UI
- `lualine.nvim` - Status line
- `lualine-lsp-progress` - LSP progress in lualine
- `fidget.nvim` - LSP progress
- `which-key.nvim` - Keybinding help
- `nvim-web-devicons` - File icons
- `nvim-notify` - Notification system
- `indent-blankline.nvim` - Indent guides

### Language Support
- `lazydev.nvim` - Lua development
- `zotcite` - Zotero citation integration for academic writing

### Language Support

**Markdown**: Enhanced with `markdown-oxide` LSP server and specialized rendering
**Lua**: Configured with `lua_ls` for Neovim development
**Nix**: Integrated with `nixd` language server for configuration management
**Go**: Supported via `gopls` language server

### Formatters & Linters

**Formatters:**
- `ruff` - Python formatting and linting
- `stylua` - Lua code formatting
- `alejandra` - Nix expression formatting
- `prettier` - Multi-language formatting for web technologies
- `rustfmt` - Rust code formatting
- `gofmt` - Go code formatting
- `shfmt` - Shell script formatting
- `clang-format` - C/C++ code formatting

**Linters:**
- `ruff` - Python linting (replaces pylint, flake8, isort, black)
- `shellcheck` - Shell script linting
- `luacheck` - Lua linting
- `statix` - Nix linting
- `cppcheck` - C/C++ linting

## Credits

This configuration is built upon the foundation provided by [BirdeeHub](https://github.com/BirdeeHub), the creator of both [nixCats](https://github.com/BirdeeHub/nixCats-nvim) and [lze](https://github.com/BirdeeHub/lze). Their work has made it possible to create a transparent, nix-native Neovim configuration that avoids the complexity and opacity of traditional plugin managers (yet I still don't really get it).
