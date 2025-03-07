{ pkgs, unstable, ... }: {

  services.home-assistant = {
    enable = true;
    extraComponents = [ "esphome" "met" "wiz" "local_todo" "google" ];
    # defaultIntegrations = [
    #   "lovelace"
    # ];
    customComponents = with pkgs.home-assistant-custom-components;
      [ adaptive_lighting ];
    customLovelaceModules =
      with unstable.home-assistant-custom-lovelace-modules; [
        light-entity-card
        mushroom
        button-card
      ];
    openFirewall = true;
    config = {
      default_config = { };
      http = {
        server_host = "0.0.0.0";
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };
      script = "!include scripts.yaml";
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
    };
  };
}
