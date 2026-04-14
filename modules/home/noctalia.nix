{ pkgs, inputs, ... }:

let
  settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;

  noctalia-wrapped = inputs.wrapper-manager.lib {
    inherit pkgs;
    modules = [
      {
        wrappers.noctalia-shell = {
          basePackage = pkgs.noctalia-shell;
          env = {
            NOCTALIA_SETTINGS_FILE.value = pkgs.writeText "config.json" (builtins.toJSON settings);
          };
        };
      }
    ];
  };
in
{
  home.packages = [ noctalia-wrapped.config.build.toplevel ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell";
      After = [
        "hyprland-session.target"
        "graphical-session.target"
      ];
      PartOf = [
        "hyprland-session.target"
        "graphical-session.target"
      ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${noctalia-wrapped.config.build.toplevel}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [
        "hyprland-session.target"
        "graphical-session.target"
      ];
    };
  };
}
