{ lib, ... }:

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

  # Hyprland sources ~/.config/hypr/noctalia.conf (written by noctalia's
  # "hyprland" theme template), which errors with "globbing: found no match"
  # on first boot before noctalia has ever run. Create an empty placeholder on
  # activation; noctalia overwrites it with real colors when it starts.
  home.activation.noctaliaHyprTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/hypr"
    touch "$HOME/.config/hypr/noctalia.conf"
  '';
}
