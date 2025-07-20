{ configs, pkgs, ... }:

{
  imports = [
    #../../home/programs/git.nix
  ];
  home = {
    username = "pixel";
    homeDirectory = "/home/pixel";
    stateVersion = "25.05";

    packages = with pkgs; [
      git
      vim
    ];


  };
}
