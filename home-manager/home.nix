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
    ghq

    tig

    emacs
  ];

  home.file.".config/tig/config".source = ./tig/config;

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

  programs.bat.enable = true;
  programs.fd.enable = true;

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--layout reverse"
      "--height 40%"
    ];
    changeDirWidgetCommand = "fd -t d";
    changeDirWidgetOptions = [
      "--preview 'eza --icons --tree --level=1 --color=always {}'"
    ];
    fileWidgetCommand = "fd -t f -L -H -E .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=header,grid --line-range :100 {}'"
    ];
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 10;
    keyMode = "vi";
    prefix = "C-q";
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    extraConfig = ''
    bind r source-file ~/.config/tmux/tmux.conf \; display Reroaded!

    # terminal settings
    set-option -sa terminal-overrides ",''${TERM}:Tc"
    set-option -g focus-events on

    bind -r n next-window
    bind -r p previous-window
    bind -r C-n next-window
    bind -r C-p previous-window

    bind -T copy-mode-vi v   send -X begin-selection
    bind -T copy-mode-vi V   send -X select-line
    bind -T copy-mode-vi C-v send -X rectangle-toggle
    bind -T copy-mode-vi y   send -X copy-selection-and-cancel
    bind -T copy-mode-vi Y   send -X copy-line-and-cancel

    set -g renumber-windows on

    # apply theme and statusline
    set -g status-interval 1
    set -g status-justify "left"
    set -g status "on"
    set -g status-left-style "none"
    set -g message-command-style "fg=#f8f8f2,bg=#6272a4"
    set -g status-right-style "none"
    set -g pane-active-border-style "fg=#bd93f9"
    set -g status-style "none,bg=#44475a"
    set -g message-style "fg=#f8f8f2,bg=#6272a4"
    set -g pane-border-style "fg=#6272a4"
    set -g status-right-length "100"
    set -g status-left-length "100"
    setw -g window-status-activity-style "none,fg=#bd93f9,bg=#44475a"
    setw -g window-status-separator ""
    setw -g window-status-style "none,fg=#f8f8f2,bg=#44475a"
    set -g status-left "#[fg=#282a36,bg=#bd93f9] #{?client_prefix,PREFIX,#S} #[fg=#bd93f9,bg=#44475a,nobold,nounderscore,noitalics]"
    setw -g window-status-current-format "#[fg=#f8f8f2,bg=#6272a4] #I:#{?#{==:''${HOME},#{pane_current_path}},~,#{b:pane_current_path}}#{?#{==:#{pane_current_command},fish},,(#{pane_current_command})} #F "
    setw -g window-status-format "#[default] #I:#{?#{==:''${HOME},#{pane_current_path}},~,#{b:pane_current_path}}#{?#{==:#{pane_current_command},fish},,(#{pane_current_command})} "
    set -g status-right "#[fg=#f8f8f2,bg=#44475a] %Y-%m-%d(%a) #[fg=#f8f8f2,bg=#6272a4] %H:%M:%S #[fg=#282a36,bg=#bd93f9] #H "
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

  programs.fish = {
    enable = true;
    shellInit = ''
    # for auto_ls
    set -g autols_cmd ls
    '';
    plugins = [
      {
        name = "fish-ghq";
        src = builtins.fetchGit {
          url = "https://github.com/decors/fish-ghq";
          rev = "cafaaabe63c124bf0714f89ec715cfe9ece87fa2";
        };
      }
      {
        name = "autols";
        src = builtins.fetchGit {
          url = "https://github.com/yuys13/autols.fish";
          rev = "1c4b6852e46cb8dd343dff2e5eca1d4a95ea132a";
        };
      }
      {
        name = "gcd";
        src = builtins.fetchGit {
          url = "https://github.com/yuys13/gcd.fish";
          rev = "b3e35ab0852d6779403ada84b1f1be03692f507a";
        };
      }
      {
        name = "fish-bd";
        src = builtins.fetchGit {
          url = "https://github.com/0rax/fish-bd";
          rev = "ab686e028bfe95fa561a4f4e57840e36902d4d7d";
        };
      }
      # {
      #   name = "pure";
      #   src = builtins.fetchGit {
      #     url = "https://github.com/pure-fish/pure";
      #     rev = "28447d2e7a4edf3c954003eda929cde31d3621d2";
      #   };
      # }
      {
        name = "bobthefish";
        src = builtins.fetchGit {
          url = "https://github.com/oh-my-fish/theme-bobthefish";
          rev = "608b0b4de6badbd574189c69023bded36875f575";
        };
      }
    ];
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
