{ ... }:

{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/yuys13/nixos-configuration.git";
        branches = {
          main = {
            name = "main";
            operation = "switch";
          };
        };
      }
    ];
  };
}
