{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.myModules.neovim;

  defaultTreesitterParsers = [
    "lua"
    "vim"
    "vimdoc"
    "regex"
    "nix"
    "bash"
    "json"
    "yaml"
    "toml"
    "markdown"
    "markdown_inline"
    "typescript"
    "javascript"
    "tsx"
    "css"
    "html"
    "python"
    "go"
    "rust"
    "dockerfile"
    "helm"
    "gotmpl"
    "hcl"
    "terraform"
    "jsonnet"
    "sql"
    "templ"
    "typst"
  ];

  defaultLspPackages = with pkgs; [
    # Language servers are installed automatically by nixvim; this list is for
    # extra executables they need.
    typescript # ts_ls
    opentofu # tofu_ls
    kubernetes-helm # helm_ls
    ansible # ansiblels
    ansible-lint # ansiblels
  ];

  plugin-99 = pkgs.vimUtils.buildVimPlugin {
    pname = "99";
    version = "master";
    src = inputs.plugin-99;
    doCheck = false;
  };
in
{
  options.myModules.neovim = {
    enable = lib.mkEnableOption "Neovim with curated plugins (via nixvim)";

    treesitterParsers = lib.mkOption {
      type = with lib.types; listOf str;
      default = defaultTreesitterParsers;
      description = "Treesitter parsers to install (passed to nvim-treesitter.withPlugins).";
    };

    lspPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = defaultLspPackages;
      description = "Extra executables to make available to Neovim (passed to nixvim.extraPackages). Language servers themselves are installed automatically by nixvim.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      nixpkgs.useGlobalPackages = true;

      extraPackages = cfg.lspPackages;

      opts = {
        number = true;
        relativenumber = true;
        cursorline = true;
        signcolumn = "yes";
        wrap = true;
        linebreak = true;
        termguicolors = true;
        expandtab = true;
        shiftwidth = 2;
        softtabstop = 2;
        tabstop = 2;
        smartindent = true;
        ignorecase = true;
        smartcase = true;
        incsearch = true;
        scrolloff = 6;
        sidescrolloff = 4;
        clipboard = "unnamedplus";
      };

      globals.mapleader = " ";

      plugins = {
        lsp = {
          enable = true;
          servers = {
            nil_ls.enable = true;
            lua_ls = {
              enable = true;
              settings = {
                Lua = {
                  diagnostics = {
                    globals = [ "vim" ];
                  };
                  workspace = {
                    checkThirdParty = false;
                  };
                };
              };
            };
            ts_ls.enable = true;
            bashls.enable = true;
            jsonls.enable = true;
            cssls.enable = true;
            html.enable = true;
            emmet_language_server.enable = true;
            yamlls.enable = true;
            marksman.enable = true;
            basedpyright.enable = true;
            ruff.enable = true;
            gopls.enable = true;

            tofu_ls = {
              enable = true;
              # lspconfig defaults to opentofu/opentofu-vars/terraform; add
              # terraform-vars so *.tfvars attaches too.
              filetypes = [
                "opentofu"
                "opentofu-vars"
                "terraform"
                "terraform-vars"
              ];
            };
            helm_ls.enable = true;
            jsonnet_ls.enable = true;
            dockerls.enable = true;
            docker_compose_language_service.enable = true;
            ansiblels = {
              enable = true;
              package = pkgs.ansible-language-server;
            };
            templ.enable = true;
            tinymist = {
              enable = true;
              settings = {
                exportPdf = "onSave";
                projectSpecification = "lockDatabase";
              };
            };
            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
          };
        };

        markdown-preview = {
          enable = true;
          settings.auto_start = 0;
        };

        render-markdown = {
          enable = true;
          settings = {
            latex.enabled = false;
          };
        };

        treesitter = {
          enable = true;
          grammarPackages = map (
            name: config.programs.nixvim.plugins.treesitter.package.builtGrammars.${name}
          ) cfg.treesitterParsers;
          highlight.enable = true;
          indent.enable = true;
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        # UI / theme
        catppuccin-nvim
        lualine-nvim
        nvim-web-devicons

        # AI
        plugin-99

        # Core + navigation
        plenary-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        harpoon
        which-key-nvim
        oil-nvim

        # Editing ergonomics
        comment-nvim
        nvim-autopairs
        mini-nvim
        leap-nvim

        # Git
        gitsigns-nvim

        # Syntax / visuals
        indent-blankline-nvim
        todo-comments-nvim
        trouble-nvim
        noice-nvim
        nvim-notify
        nui-nvim
        precognition-nvim

        # Completion & LSP glue
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        luasnip
        friendly-snippets
        nvim-lspconfig

        # Terminals
        toggleterm-nvim
      ];

      extraConfigLua = builtins.readFile ./neovim/config.lua;
    };
  };
}
