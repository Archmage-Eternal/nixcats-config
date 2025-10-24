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
          # Always available: basic markdown tools
          pandoc
          nodePackages.mermaid-cli
        ] ++ (if categories.zettelkasten or false then [
          # Zettelkasten-specific: advanced LSP features
          markdown-oxide
        ] else []);

        debug = with pkgs; {
          python = [ python313Packages.debugpy ];
          go = [ delve ];
        };

        python = with pkgs; [
          python3
          pyright
          pylint
          mypy
          black
          isort
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
          ];
          extra = [
            oil-nvim
            nvim-web-devicons
          ];
        };

        markdown = with pkgs.vimPlugins; (if categories.zettelkasten or false then [
          # Full markdown experience for zettelkasten
          markview-nvim
        ] else [
          # Basic markdown for general use
        ]);

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
        "python.debug" = with pkgs.vimPlugins; [ nvim-dap-python ];
        "go.debug" = with pkgs.vimPlugins; [ nvim-dap-go ];
        
        # Language-specific plugins
        rust = with pkgs.vimPlugins; [ rust-tools-nvim ];
        lua = with pkgs.vimPlugins; [ lazydev-nvim ];

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

      extraWrapperArgs = pkgs.lib.optionalAttrs (categories.zettelkasten or false) {
        "--prefix" = "PATH : ${pkgs.lib.makeBinPath [ pkgs.markdown-oxide ]}";
      };

      # python3.libraries = {};
      # extraLuaPackages = {};

      extraCats = {
        python = [
          ["debug" "python"]
        ];
        go = [
          ["debug" "go"]
        ];
        # markdown uses conditional logic directly, no extraCats needed
        # rust, lua, javascript, nix, c_cpp don't need extraCats mappings
      };
    };

    packageDefinitions = {
      # 1. Full coding - all features and debugging (aliases: vi, vim)
      nixCats = { pkgs, ... }: {
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
          colorscheme = "catppuccin";

          lint = true;
          format = true;

          python = true;
          go = true;
          rust = true;
          lua = true;
          nix = true;
          javascript = true;
          c_cpp = true;

          markdown = true;
          zettelkasten = false;

          lspDebugMode = false;
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };

      nixCats-zk = { pkgs, ... }: {
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
          colorscheme = "catppuccin";

          lint = true;
          format = true;

          markdown = true;
          zettelkasten = true;

          lua = true;
          nix = true;
          
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
