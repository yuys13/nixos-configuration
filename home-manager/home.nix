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

  home = {
    username = "yuys13";
    homeDirectory = "/home/yuys13";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
