{ config, config_dir, pkgs, ... }: {
  programs.firefox.enable = true;
  programs.firefox.profiles.MLFlexer.search.engines = {

    "Nix Packages" = {
      urls = [{
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "type";
            value = "packages";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }];

      icon =
        "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };

    "NixOS Wiki" = {
      urls = [{
        template = "https://wiki.nixos.org/index.php?search={searchTerms}";
      }];
      iconUpdateURL = "https://wiki.nixos.org/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@nw" ];
    };

    "Bing".metaData.hidden = true;
    "Google".metaData.alias =
      "@g"; # builtin engines only support specifying one additional alias

  };

}
