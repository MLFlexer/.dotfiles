{ lib, config, ... }: {

  options = {
    searx.enable = lib.mkEnableOption "Enables searx";
    searx.port = lib.mkOption { default = 8080; };
  };

  config = lib.mkIf config.searx.enable {
    services.searx = {
      enable = true;
      settings = {
        server.port = config.searx.port;
        server.bind_address = "0.0.0.0";
        # server.secret_key = "Vanish5099";

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

