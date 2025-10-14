{ inputs, config, pkgs, lib, ... }:

{
  home = {
    username = lib.mkDefault "pixel";
    homeDirectory = lib.mkDefault "/home/pixel";
    stateVersion = lib.mkDefault "24.05";
  };

  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "git";
    };
  };

  home.sessionsVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
