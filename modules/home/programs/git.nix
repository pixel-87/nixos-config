{ config, pkgs, ... }:

{ 
  programs.git = {
    enable = true;

    userName = "pixel";
    userEmail = "edwardoliverthomas@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      color.ui = true;
      status.branch = true;

      push.default = "current";

      diff.compactionHeuristic = true;
      diff.colorMoved = "zebra";
    };
  };
}
