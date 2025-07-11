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
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
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
        # General Tools (used by multiple plugins / LSPs)
        general = with pkgs; [
          ripgrep
          fd
          universal-ctags
        ];

        # Linters
        lint = with pkgs; [
          # Python
          pylint
          mypy

          # JavaScript / TypeScript
          eslint

          # Rust
          clippy

          # Nix
          statix

          # Lua
          lua54Packages.luacheck
        ];

        # Formatters
        format = with pkgs; [
          # Python
          black
          isort

          # JavaScript / TypeScript
          prettier

          # Lua
          stylua

          # Nix
          alejandra
        ];

        # Debuggers
        debug = with pkgs; {
          go = [delve];
          python = [python313Packages.debugpy];
          c_cpp = [gdb];
        };

        # Language-Specific Toolchains / LSPs

        python = with pkgs; [
          python3Full
          pyright
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
        ];

        javascript = with pkgs; [
          nodejs
          typescript
          typescript-language-server
        ];

        lua = with pkgs; [
          lua-language-server
        ];

        nix = with pkgs; [
          nixd
          nix-doc
        ];
        c_cpp = with pkgs; [
          gcc
          clang
          clang-tools
          cmake
          gnumake
          cppcheck
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        debug = with pkgs.vimPlugins; [
          nvim-nio
        ];
        general = with pkgs.vimPlugins; {
          always = [
            lze
            lzextras
            vim-repeat
            plenary-nvim
            nvim-notify
          ];
          extra = [
            oil-nvim
            nvim-web-devicons
          ];
        };

        themer = with pkgs.vimPlugins; (
          builtins.getAttr (categories.colorscheme or "tokyonight") {
            "onedark" = onedark-nvim;
            "catppuccin" = catppuccin-nvim;
            "catppuccin-mocha" = catppuccin-nvim;
            "tokyonight" = tokyonight-nvim;
            "tokyonight-day" = tokyonight-nvim;
          }
        );
      };

      optionalPlugins = {
        debug = with pkgs.vimPlugins; {
          default = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];
          go = [nvim-dap-go];
          python = [nvim-dap-python];
          rust = [rust-tools-nvim];
          lua = [lazydev-nvim];
        };
        lint = with pkgs.vimPlugins; [
          nvim-lint
        ];
        format = with pkgs.vimPlugins; [
          conform-nvim
        ];
        markdown = with pkgs.vimPlugins; [
          markview-nvim
        ];
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
            # nvim-treesitter.withAllGrammars
            (nvim-treesitter.withPlugins (
              plugins:
                with plugins; [
                  nix
                  lua
                  rust
                  go
                  python
                  c
                  cpp
                  bash
                ]
            ))
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

      sharedLibraries = {
        # general = with pkgs; [];
      };

      environmentVariables = {
      };

      extraWrapperArgs = {};

      python3.libraries = {};
      extraLuaPackages = {};

      extraCats = {
        debug = [
          ["debug" "default"]
        ];
        go = [
          ["debug" "go"]
        ];
        c_cpp = [
          ["debug" "c_cpp"]
        ];
        python = [
          ["debug" "python"]
        ];
        rust = [
          ["debug" "rust"]
        ];
      };
    };

    packageDefinitions = {
      nixCats = {
        pkgs,
        name,
        ...
      } @ misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = ["vi" "vim" "nvim"];

          wrapRc = true;
          configDirName = "nixCats-nvim";
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          general = true;
          lint = true;
          format = true;
          markdown = true;
          go = true;
          rust = true;
          python = true;
          lua = true;
          c_cpp = true;
          nix = true;
          javascript = true;

          lspDebugMode = false;
          themer = true;
          colorscheme = "tokyonight";
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
