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

      colorscheme = "catppuccin-mocha";
      colorschemes.catppuccin.enable = true;

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
        comment.enable = true;
        indent-blankline.enable = true;

        leap.enable = true;

        lualine = {
          enable = true;
          settings.options.theme = "auto";
        };

        mini-ai.enable = true;
        mini-surround.enable = true;

        nvim-autopairs.enable = true;

        oil = {
          enable = true;
          settings.view_options.show_hidden = true;
        };

        telescope = {
          enable = true;

          settings.defaults.mappings.i = {
            "<C-k>" = "move_selection_previous";
            "<C-j>" = "move_selection_next";
          };

          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
          };

          extensions.fzf-native.enable = true;
        };

        todo-comments.enable = true;
        web-devicons.enable = true;
        which-key.enable = true;

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

        conform-nvim = {
          enable = true;
          autoInstall.enable = true;

          settings = {
            formatters_by_ft = {
              bash = [ "shfmt" ];
              css = [ "prettierd" ];
              go = [ "gofumpt" ];
              hcl = [ "tofu_fmt" ];
              html = [ "prettierd" ];
              javascript = [ "prettierd" ];
              json = [ "prettierd" ];
              jsonnet = [ "jsonnetfmt" ];
              lua = [ "stylua" ];
              markdown = [ "prettierd" ];
              nix = [ "nixfmt" ];
              python = [ "ruff_format" ];
              rust = [ "rustfmt" ];
              sh = [ "shfmt" ];
              terraform = [ "tofu_fmt" ];
              toml = [ "taplo" ];
              tsx = [ "prettierd" ];
              typescript = [ "prettierd" ];
              yaml = [ "yamlfmt" ];
              "yaml.ansible" = [ "yamlfmt" ];
              "yaml.docker-compose" = [ "yamlfmt" ];
              "yaml.helm-values" = [ "yamlfmt" ];
            };

            format_on_save = {
              lsp_format = "fallback";
            };
          };
        };

        cmp = {
          enable = true;

          settings = {
            snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

            mapping.__raw = ''
              cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require("luasnip").expand_or_jumpable() then
                    require("luasnip").expand_or_jump()
                  else
                    fallback()
                  end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
              })
            '';

            sources = [
              {
                name = "nvim_lsp";
                group_index = 1;
              }
              {
                name = "luasnip";
                group_index = 1;
              }
              {
                name = "buffer";
                group_index = 2;
              }
              {
                name = "path";
                group_index = 2;
              }
            ];
          };

          cmdline = {
            "/" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [ { name = "buffer"; } ];
            };
            "?" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [ { name = "buffer"; } ];
            };
            ":" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [
                { name = "path"; }
                { name = "cmdline"; }
              ];
            };
          };
        };

        luasnip = {
          enable = true;
          fromVscode = [ { } ];
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
        # AI
        plugin-99

        # Core + navigation
        plenary-nvim
        harpoon

        # Git
        gitsigns-nvim

        # Syntax / visuals
        trouble-nvim
        noice-nvim
        nvim-notify
        nui-nvim
        precognition-nvim

        # Completion & LSP glue
        friendly-snippets

        # Terminals
        toggleterm-nvim
      ];

      extraConfigLua = builtins.readFile ./neovim/config.lua;
    };
  };
}
