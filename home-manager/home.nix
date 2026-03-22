{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs/common
    ./programs/git
    ./programs/neovim
    ./programs/tmux
    ./programs/fish
    ./programs/fzf
    ./programs/direnv
    ./programs/tig
  ];

  home.username = "yuys13";
  home.homeDirectory = "/home/yuys13";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
