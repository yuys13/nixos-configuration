{
  config,
  pkgs,
  ...
}:
let
  sources = pkgs.callPackage ../_sources/generated.nix { };
in
{
  imports = [ ./home.nix ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";

        font = "HackGen Console NF:size=14";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 14;
        normal = {
          family = "HackGen Console NF";
          style = "Regular";
        };
        bold = {
          family = "HackGen Console NF";
          style = "Bold";
        };
      };
    };
  };

  # wayland.windowManager.sway = {
  #   enable = true;
  #   extraConfig = ''
  #     output Virtual-1 resolution 1920x1080
  #   '';
  # };

}
