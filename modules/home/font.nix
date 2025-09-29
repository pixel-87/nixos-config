{ pkgs, ... }:

{
  font.packages = with pkgs; [
    maple-mono.NF-unhinted;
  ];
}
