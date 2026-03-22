{ pkgs, ... }:
{
  home.packages = [ pkgs.tig ];
  xdg.configFile."tig/config".source = ./config;
}
