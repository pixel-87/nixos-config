{
  imports = [ ../../modules/home/profiles/gui.nix ];

  # Configure git
  myModules.git.userEmail = "edwardoliverthomas@gmail.com";

  # Enable pentesting tools
  myModules.pentesting.enable = true;

  myModules.fastfetch.enable = true;
  myModules.starship.enable = true;

  myModules.opencode = {
    enable = true;
    plugins = [ "opencode-gemini-auth@latest" ];
  };

  myModules.egm.enable = true;
}
