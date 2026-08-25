{ pkgs, ... }:

{
  stylix = {
    enable = true;
    image = ../../assets/nixos_logo_1.webp;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    opacity = {
      terminal = 0.85;
      popups = 0.90;
    };
  };
}
