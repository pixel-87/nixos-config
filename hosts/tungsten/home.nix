{
  imports = [ ../../modules/home/profiles/gui.nix ];

  home = {
    username = "pixel";
    homeDirectory = "/home/pixel";
  };

  myModules = {
    # Configure git
    git.userEmail = "edwardoliverthomas@gmail.com";

    # Enable pentesting tools
    pentesting.enable = true;

    fastfetch.enable = true;
    starship.enable = true;

    opencode = {
      enable = true;
      plugins = [ "opencode-gemini-auth@latest" ];
    };

    egm.enable = true;
  };
}
