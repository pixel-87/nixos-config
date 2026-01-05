{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.git;
in
{
  options.myModules.git = {
    enable = lib.mkEnableOption "git version control with sensible defaults";

    userName = lib.mkOption {
      type = lib.types.str;
      default = "pixel";
      description = "Git user name for commits";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git user email for commits";
    };

    defaultBranch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Default branch name for new repositories";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };

        init.defaultBranch = cfg.defaultBranch;
        pull.rebase = true;
        color.ui = true;
        status.branch = true;
        push.default = "current";
        diff = {
          compactionHeuristic = true;
          colorMoved = "zebra";
        };
      };
    };
  };
}
