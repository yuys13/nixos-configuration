{ pkgs, ... }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
{
  home.packages = with pkgs; [
    neovim
    neovim-remote
    gcc
    gitlint
    tree-sitter
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim" = {
    source = sources.dotfiles.src + "/home/XDG_CONFIG_HOME/nvim";
    recursive = true;
  };

  xdg.configFile."fish/functions/vi.fish" = {
    source = sources.dotfiles.src + "/home/XDG_CONFIG_HOME/fish/functions/vi.fish";
  };

  programs.git.ignores = [
    ".nvim.lua"
    ".nvimrc"
    ".exrc"
  ];
}
