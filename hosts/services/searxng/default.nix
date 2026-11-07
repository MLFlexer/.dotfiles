{ lib, config, ... }:
{

  options = {
    searx.enable = lib.mkEnableOption "Enables searx";
    searx.domain = lib.mkOption { default = "search.mlflexer.online"; };
    searx.port = lib.mkOption { default = 6040; };
  };

  config = lib.mkIf config.searx.enable {
    services.searx = {
      enable = true;
      domain = config.searx.domain;
      settings = {
        server.port = config.searx.port;
        server.bind_address = "localhost";
        server.secret_key = "$SEARX_SECRET_KEY";

        # engines = [{
        #   name = "wolframalpha";
        #   shortcut = "wa";
        #   api_key = "@WOLFRAM_API_KEY@";
        #   engine = "wolframalpha_api";
        # }];
      };
    };
  };
}
