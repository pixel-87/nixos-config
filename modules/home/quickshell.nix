{ pkgs, ... }:

{
  programs.quickshell = {
    enable = true;
    systemd.enable = true;

    package = pkgs.symlinkJoin {
      name = "quickshell-wrapped";
      paths = with pkgs; [
        (pkgs.writeShellScriptBin "quickshell" ''
          export QML2_IMPORT_PATH="${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}:$QML2_IMPORT_PATH"
          exec ${pkgs.quickshell}/bin/quickshell "$@"
        '')
        quickshell
        kdePackages.qtimageformats
        kdePackages.ksystemstats
        qt6.qtsvg
        qt6.qt5compat
        kdePackages.breeze-icons
        cosmic-icons
        networkmanagerapplet
        upower
        procps
      ];
      meta.mainProgram = "quickshell";
    };
  };

  # This links your QML config directory
  xdg.configFile."quickshell" = {
    source = ./hyprland/quickshell;
    recursive = true;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # 2. This tells the quickshell service to wait
  #    for the graphical session to be ready.
  systemd.user.services.quickshell = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Unit.Requires = [ "graphical-session.target" ];
  };
}
