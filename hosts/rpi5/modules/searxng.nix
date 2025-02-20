{
  services.searx.enable = false;
  services.searx.settings = {
    server.port = 8080;
    server.bind_address = "0.0.0.0";
    server.secret_key = "Vanish5099";

    engines = [{
      name = "wolframalpha";
      shortcut = "wa";
      api_key = "@WOLFRAM_API_KEY@";
      engine = "wolframalpha_api";
    }];
  };
}
