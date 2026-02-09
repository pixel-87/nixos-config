{ lib, config, ... }:
let
  inherit (lib) concatStrings;

  cfg = config.myModules.starship;
in
{
  options.myModules.starship = {
    enable = lib.mkEnableOption "starship prompt";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      settings = {
        add_newline = true;
        format = concatStrings [
          "[╭╴](238)$os"
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_status"
          "$package"
          "$python"
          "$nodejs"
          "$lua"
          "$rust"
          "$java"
          "$c"
          "$golang"
          "$nix_shell"
          "$docker_context"
          "$container"
          "\n[╰─](237)$character"
        ];

        character = {
          success_symbol = "";
          error_symbol = "";
        };

        username = {
          style_user = "white";
          style_root = "black";
          format = "[$user]($style)";
          show_always = true;
        };

        hostname = {
          ssh_only = false;
          format = "@[$hostname]($style) ";
          style = "bold white";
        };

        directory = {
          style = "bold blue";
          truncation_length = 3;
          truncation_symbol = "…/";
          home_symbol = "~";
          read_only_style = "197";
          read_only = " 🔒";
          format = "[$path]($style)[$read_only]($read_only_style) ";

          substitutions = {
            "Documents" = "📄 Documents";
            "Downloads" = "📥 Downloads";
            "Music" = "🎵 Music";
            "Pictures" = "🖼️ Pictures";
            "Videos" = "🎬 Videos";
            "code" = "💻 code";
            ".config" = "⚙️ .config";
          };
        };

        os = {
          style = "bold white";
          format = "[$symbol]($style)";

          symbols = {
            Arch = "";
            Artix = "";
            Debian = "";
            EndeavourOS = "";
            Fedora = "";
            NixOS = "";
            openSUSE = "";
            SUSE = "";
            Ubuntu = "";
            Raspbian = "";
            Gentoo = "";
            CentOS = "";
            Mint = "";
            Alpine = "";
            Manjaro = "";
            Macos = "";
            Linux = "";
            Windows = "";
          };
        };

        # Package version
        package = {
          format = "is [$symbol$version]($style) ";
          symbol = " ";
          style = "208 bold";
          display_private = false;
        };

        # Language modules with versions
        container = {
          symbol = "⬢ ";
          format = "via [$symbol]($style)";
          style = "yellow dimmed";
        };

        python = {
          symbol = " ";
          format = "via [$symbol$version]($style) ";
          style = "yellow";
        };

        nodejs = {
          symbol = " ";
          format = "via [$symbol$version]($style) ";
          style = "green";
        };

        lua = {
          symbol = " ";
          format = "via [$symbol$version]($style) ";
          style = "blue";
        };

        rust = {
          symbol = " ";
          format = "via [$symbol$version]($style) ";
          style = "red";
        };

        java = {
          symbol = " ";
          format = "via [$symbol$version]($style) ";
          style = "red";
        };

        c = {
          symbol = " ";
          format = "via [$symbol$version]($style) ";
          style = "blue";
        };

        golang = {
          symbol = " ";
          format = "via [$symbol$version]($style) ";
          style = "cyan";
        };

        docker_context = {
          symbol = " ";
          format = "via [$symbol]($style)";
          style = "blue";
        };

        nix_shell = {
          symbol = " ";
          format = "via [$symbol]($style) ";
          style = "blue";
        };

        git_branch = {
          symbol = " ";
          format = "on [$symbol$branch]($style) ";
          truncation_length = 4;
          truncation_symbol = "…/";
          style = "bold green";
        };

        git_status = {
          format = "[\\($all_status$ahead_behind\\)]($style) ";
          style = "bold green";
          conflicted = "🏳";
          up_to_date = " ";
          untracked = " ";
          ahead = "⇡\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          behind = "⇣\${count}";
          stashed = " ";
          modified = " ";
          staged = "[++\\($count\\)](green)";
          renamed = " ";
          deleted = " ";
        };

        battery.disabled = true;
        gcloud.disabled = true;
      };
    };
  };
}
