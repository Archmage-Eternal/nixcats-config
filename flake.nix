{
  description = "Just another Lua-natic's nixCats' flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    "plugins-hlargs" = {
      url = "github:m-demare/hlargs.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    extra_pkg_config = {};

    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    } @ packageDef: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          ripgrep
          fd
          universal-ctags
        ];

        markdown = with pkgs; [
          markdown-oxide
        ];

        zettelkasten = with pkgs; [
          sqlite
          pandoc
          nodePackages.mermaid-cli
          python313Packages.pyyaml
        ];

        spellcheck = with pkgs; [
          ltex-ls # LTeX Language Server for grammar and spell check
        ];

        debug = with pkgs; {
          python = [python313Packages.debugpy];
          go = [delve];
        };

        python = with pkgs; [
          python3
          uv
          ruff
          basedpyright
        ];

        go = with pkgs; [
          go
          gopls
          gotools
          go-tools
          gccgo
        ];

        rust = with pkgs; [
          rustc
          cargo
          rust-analyzer
          clippy
          rustfmt
        ];

        javascript = with pkgs; [
          nodejs
          typescript
          typescript-language-server
          eslint
          prettier
        ];

        lua = with pkgs; [
          lua-language-server
          lua54Packages.luacheck
          stylua
        ];

        nix = with pkgs; [
          nixd
          nix-doc
          statix
          alejandra
        ];

        shell = with pkgs; [
          shellcheck
          bash-language-server
          shfmt
        ];

        c_cpp = with pkgs; [
          gcc
          clang
          clang-tools
          cmake
          gnumake
          cppcheck
          gdb
        ];
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; {
          always = [
            lze
            lzextras
            vim-repeat
            plenary-nvim
            nvim-notify
            nvim-nio
            snacks-nvim
          ];
          extra = [
            nvim-web-devicons
          ];
        };

        markdown = with pkgs.vimPlugins; [
          markview-nvim
        ];

        zettelkasten = with pkgs.vimPlugins; [
          zotcite
        ];

        themer = with pkgs.vimPlugins; (
          builtins.getAttr (categories.colorscheme or "tokyonight") {
            "catppuccin" = catppuccin-nvim;
            "catppuccin-mocha" = catppuccin-nvim;
            "tokyonight" = tokyonight-nvim;
          }
        );
      };

      optionalPlugins = {
        # Core development tools (shared across languages)
        lint = with pkgs.vimPlugins; [
          nvim-lint
        ];

        format = with pkgs.vimPlugins; [
          conform-nvim
        ];

        debug = with pkgs.vimPlugins; [
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
        ];

        # Language-specific debug plugins
        "python.debug" = with pkgs.vimPlugins; [nvim-dap-python];
        "go.debug" = with pkgs.vimPlugins; [nvim-dap-go];

        # Language-specific plugins
        rust = with pkgs.vimPlugins; [
          # rust-tools-nvim  # Deprecated - use rustaceanvim when ready for advanced Rust features
        ];
        lua = with pkgs.vimPlugins; [lazydev-nvim];

        # markdown: Markview plugin loaded via startupPlugins
        general = {
          completion = with pkgs.vimPlugins; [
            luasnip
            cmp-cmdline
            blink-cmp
            blink-compat
            colorful-menu-nvim
          ];
          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars
          ];
          telescope = with pkgs.vimPlugins; [
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            telescope-nvim
          ];
          always = with pkgs.vimPlugins; [
            nvim-lspconfig
            lualine-nvim
            gitsigns-nvim
            vim-sleuth
            vim-fugitive
            vim-rhubarb
            nvim-surround
            nui-nvim
          ];

          extra = with pkgs.vimPlugins; [
            fidget-nvim
            lualine-lsp-progress
            which-key-nvim
            comment-nvim
            undotree
            indent-blankline-nvim
            vim-startuptime
            pkgs.neovimPlugins.hlargs
          ];
        };
      };

      # sharedLibraries = {};
      # environmentVariables = {};
      # extraWrapperArgs = {};
      # python3.libraries = {};
      # extraLuaPackages = {};

      extraCats = {
        python = [
          ["debug" "python"]
        ];
        go = [
          ["debug" "go"]
        ];
        zettelkasten = [
          ["markdown" "zettelkasten"]
        ];
        # rust, lua, javascript, nix, c_cpp don't need extraCats mappings
      };
    };

    packageDefinitions = {
      # 1. Full coding - all features and debugging (aliases: vi, vim)
      nixCats = {pkgs, ...}: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = ["vi" "vim"];

          wrapRc = true;
          configDirName = "nixCats-nvim";
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          general = true;
          themer = true;
          colorscheme = "tokyonight";

          lint = true;
          format = true;

          python = true;
          go = true;
          rust = true;
          lua = true;
          nix = true;
          javascript = true;
          c_cpp = true;
          shell = true;

          markdown = true;
          zettelkasten = true;
          spellcheck = true;

          lspDebugMode = false;
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };

      nixCats-zk = {pkgs, ...}: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = ["zk"];

          wrapRc = true;
          configDirName = "nixCats-nvim";
          hosts.python3.enable = false;
          hosts.node.enable = false;
        };
        categories = {
          general = true;
          themer = true;
          colorscheme = "tokyonight";

          lint = true;
          format = true;

          markdown = true;
          zettelkasten = true;
          spellcheck = true;

          lua = false;
          nix = false;

          python = false;
          go = false;
          rust = false;
          javascript = false;
          c_cpp = false;

          lspDebugMode = false;
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };
    };

    defaultPackageName = "nixCats";
  in
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;

      pkgs = import nixpkgs {inherit system;};
    in {
      packages = utils.mkAllWithDefault defaultPackage;

      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // (let
      nixosModule = utils.mkNixosModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      homeModule = utils.mkHomeModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
