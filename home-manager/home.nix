{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs/common
    ./programs/bat
    ./programs/git
    ./programs/neovim
    ./programs/tmux
    ./programs/fish
    ./programs/fzf
    ./programs/direnv
    ./programs/tig
    ./programs/pip
  ];

  home = {
    username = "yuys13";
    homeDirectory = "/home/yuys13";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
