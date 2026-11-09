{ ... }:
{
  # fromTOML keeps the settings in a reviewable TOML file but evaluates as an
  # attrset so stylix's noctalia integration (theme/fonts/opacity) can merge.
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = builtins.fromTOML (builtins.readFile ./noctalia.toml);
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
