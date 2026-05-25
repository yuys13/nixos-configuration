{ pkgs, ... }:
{
  home.packages = [ pkgs.ghq ];

  programs.git.settings.ghq.root = "~/src";
}
