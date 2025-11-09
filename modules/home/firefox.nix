{ config, pkgs, lib, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.pixel = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        consent-o-matic
      ];
    };
  };
}
