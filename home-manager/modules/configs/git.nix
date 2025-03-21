{ config, lib, ... }: {

  options = { git.enable = lib.mkEnableOption "Enables Git config"; };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          syntax-theme = "tokoyonight_moon";
          line-numbers = true;
        };
      };
      userEmail = "75012728+MLFlexer@users.noreply.github.com";
      userName = "MLFlexer";
    };

    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --paging=never";
          };
        };
      };
    };
  };
}
