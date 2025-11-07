{ config, pkgs, ... }:

{ 
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "pixel";
        email = "edwardoliverthomas@gmail.com";
      };

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
