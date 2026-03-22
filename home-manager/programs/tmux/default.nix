{ pkgs, ... }: {
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

      # split
      bind '"' split-window -v -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

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
}
