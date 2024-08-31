{ config, pkgs, ... }:

{
  home.username = "yuys13";
  home.homeDirectory = "/home/yuys13";

  home.packages = with pkgs; [
    fastfetch

    zip
    xz
    unzip
    p7zip

    ripgrep
    jq
    eza
    fzf
    ghq

    tig
  ];

  programs.git = {
    enable = true;
    userName = "yuys13";
    userEmail = "yuys13@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultbranch = "main";
      };
      commit = {
        verbose = true;
      };
      push = {
        default = "current";
        useForceIfInclues = true;
      };
      pull = {
        ff = "only";
      };
      diff = {
        tool = "nvimdiff";
      };
      difftool = {
        trustExitCode = true;
      };
      merge = {
        tool = "nvimdiff";
      };
      mergetool = {
        "vimdiff".trustExitCode = true;
        "nvimdiff".trustExitCode = true;
      };
      blame = {
        markIgnoredLines = true;
      };
      ghq = {
        root = "~/src";
      };
    };
  };

  programs.gh.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    extraConfig = ''
      set number
      set list
      set expandtab
      inoremap jj <Esc>
    '';
  };

  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     env.TERM = "xterm-256color";
  #     font = {
  #       size = 14;
  #       normal = {
  #         family = "HackGen Console NF";
  #         style = "Regular";
  #       };
  #       bold = {
  #         family = "HackGen Console NF";
  #         style = "Bold";
  #       };
  #     };
  #   };
  # };

  programs.fish.enable = true;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
