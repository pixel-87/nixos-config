{ inputs, config, pkgs, lib, ... }:

{
  home = {
    username = lib.mkDefault "pixel";
    homeDirectory = lib.mkDefault "/home/pixel";
    stateVersion = lib.mkDefault "24.05";

    packages = with pkgs; [
      gammastep
      geoclue2
    ];
  };

  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "git";
    };
  };

  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
