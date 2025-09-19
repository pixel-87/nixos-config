{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    
    extensions = pkgs.firefox-addons; [ 
      ublock-origin
      Consent-O-Matic
    ]:
  };
}
