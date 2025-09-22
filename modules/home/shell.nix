{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      rm = "rm -i";
      ".." = "cd ..";
      l = "ls -alh";
    };
  };
}
