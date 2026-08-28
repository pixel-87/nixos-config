{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = ../../assets/nixos_logo_1.webp;
    base16Scheme = "${inputs.stylix.inputs.tinted-schemes}/base16/catppuccin-mocha.yaml";
    polarity = "dark";

    opacity = {
      terminal = 0.85;
      popups = 0.90;
    };
  };
}
