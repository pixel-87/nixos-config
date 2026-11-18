{
  config,
  lib,
  pkgs,
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
        mouse = "a";
        splitbelow = true;
        splitright = true;
      };

      diagnostic.settings = {
        severity_sort = true;
        update_in_insert = false;
        underline = true;
        signs = true;
        float = {
          border = "rounded";
          source = true;
        };
      };

      globals.mapleader = " ";

      keymaps = [
        {
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options.desc = "Diagnostics (workspace)";
        }
        {
          key = "<leader>xX";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options.desc = "Diagnostics (buffer)";
        }
        {
          key = "<leader>cs";
          action = "<cmd>Trouble symbols toggle focus=false<cr>";
          options.desc = "Symbols";
        }
        {
          key = "<leader>cl";
          action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
          options.desc = "LSP references";
        }
        {
          key = "<leader>xL";
          action = "<cmd>Trouble loclist toggle<cr>";
          options.desc = "Location list";
        }
        {
          key = "<leader>xQ";
          action = "<cmd>Trouble qflist toggle<cr>";
          options.desc = "Quickfix list";
        }
        {
          key = "<leader>ha";
          action.__raw = ''function() require("harpoon"):list():add() end'';
          options.desc = "Harpoon add file";
        }
        {
          key = "<leader>hh";
          action.__raw = ''function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end'';
          options.desc = "Harpoon list";
        }
        {
          key = "<leader>hn";
          action.__raw = ''function() require("harpoon"):list():next() end'';
          options.desc = "Harpoon next file";
        }
        {
          key = "<leader>hp";
          action.__raw = ''function() require("harpoon"):list():prev() end'';
          options.desc = "Harpoon prev file";
        }
        {
          key = "<leader>h1";
          action.__raw = ''function() require("harpoon"):list():select(1) end'';
          options.desc = "Harpoon file 1";
        }
        {
          key = "<leader>h2";
          action.__raw = ''function() require("harpoon"):list():select(2) end'';
          options.desc = "Harpoon file 2";
        }
        {
          key = "<leader>h3";
          action.__raw = ''function() require("harpoon"):list():select(3) end'';
          options.desc = "Harpoon file 3";
        }
        {
          key = "<leader>h4";
          action.__raw = ''function() require("harpoon"):list():select(4) end'';
          options.desc = "Harpoon file 4";
        }
        {
          key = "<leader>oo";
          action = "<cmd>AerialToggle<cr>";
          options.desc = "Outline";
        }
        {
          key = "<leader>oj";
          action = "<cmd>AerialNext<cr>";
          options.desc = "Next symbol";
        }
        {
          key = "<leader>ok";
          action = "<cmd>AerialPrev<cr>";
          options.desc = "Previous symbol";
        }
        {
          key = "<leader>tp";
          action.__raw = ''function() require("precognition").toggle() end'';
          options.desc = "Toggle Precognition";
        }
      ];

      plugins = {
        aerial = {
          enable = true;
          settings = {
            backends = [
              "treesitter"
              "lsp"
            ];
            attach_mode = "global";
            highlight_on_hover = true;
            layout.default_direction = "right";
          };
        };

        comment.enable = true;
        gitsigns = {
          enable = true;

          settings.on_attach = ''
            function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              map("n", "]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
              end, { expr = true, desc = "Next git hunk" })

              map("n", "[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
              end, { expr = true, desc = "Prev git hunk" })

              map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview git hunk" })
              map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset git hunk" })
              map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset git hunk (visual)" })
              map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset git buffer" })
              map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Git blame line" })
              map("n", "<leader>gd", gs.diffthis, { desc = "Git diff this" })
              map("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Git diff this ~" })
            end
          '';
        };

        indent-blankline.enable = true;

        harpoon.enable = true;

        leap.enable = true;

        lualine = {
          enable = true;
          settings = {
            options.theme = "auto";

            # A single space keeps the winbar occupied when navic has no
            # context. Do not use U+200B: Neovim treats it as unprintable and
            # renders it literally as "<200b>". Disable the component
            # separator so no powerline glyph is drawn after the breadcrumbs.
            winbar.lualine_c = [
              {
                __unkeyed-1 = "navic";
                separator = "";
              }
              {
                __unkeyed-1.__raw = ''function() return " " end'';
              }
            ];
            inactive_winbar.lualine_c = [
              {
                __unkeyed-1 = "navic";
                separator = "";
              }
              {
                __unkeyed-1.__raw = ''function() return " " end'';
              }
            ];
          };
        };

        mini-ai.enable = true;
        mini-surround.enable = true;

        navic = {
          enable = true;
          settings = {
            lsp.auto_attach = true;
            highlight = true;
          };
        };

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
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
            }
            {
              __unkeyed-1 = "<leader>h";
              group = "Harpoon";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "Diagnostics";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Code";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "LSP";
            }
            {
              __unkeyed-1 = "<leader>o";
              group = "Outline";
            }
          ];
        };

        noice = {
          enable = true;
          settings = {
            lsp = {
              progress.enabled = false;
              override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
              };
            };
            presets = {
              command_palette = true;
              lsp_doc_border = true;
            };
          };
        };

        notify.enable = true;

        precognition = {
          enable = true;
          settings.startVisible = false;
        };

        toggleterm = {
          enable = true;
          settings = {
            open_mapping = "[[<c-\\>]]";
            shade_terminals = true;
            shading_factor = 2;
            direction = "horizontal";
          };
        };

        trouble.enable = true;

        lsp = {
          enable = true;

          keymaps = {
            lspBuf = {
              gd = "definition";
              gr = "references";
              gi = "implementation";
              K = "hover";
              "<leader>rn" = "rename";
              "<leader>ca" = "code_action";
            };

            diagnostic = {
              "[d" = "goto_prev";
              "]d" = "goto_next";
              "<leader>ld" = "open_float";
            };

            extra = [
              {
                key = "<leader>lf";
                action.__raw = ''
                  function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                  end
                '';
                options.desc = "Format buffer";
              }
            ];
          };

          servers = {
            nixd = {
              enable = true;
              settings.nixpkgs.expr = ''
                import (builtins.getFlake "${config.myModules.shell.flakePath}").inputs.nixpkgs { }
              '';
            };
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
            basedpyright = {
              enable = true;
              settings.python.analysis = {
                autoSearchPaths = true;
                useLibraryCodeForTypes = true;
                diagnosticMode = "openFilesOnly";
              };
            };
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
        # Core + navigation
        plenary-nvim

        # Snippets (loaded by luasnip)
        friendly-snippets
      ];

      extraConfigLua = builtins.readFile ./neovim/config.lua;
    };
  };
}
