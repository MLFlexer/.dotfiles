{ lib, config, pkgs, unstable, ... }: {

  options = {
    home-assistant.enable = lib.mkEnableOption "Enables home-assistant";
    home-assistant.domain = lib.mkOption { default = "ha.mlflexer.online"; };
    home-assistant.port = lib.mkOption { default = 8123; };
  };

  config = lib.mkIf config.home-assistant.enable {
    services.home-assistant = {
      enable = true;
      extraComponents = [ "esphome" "met" "wiz" "local_todo" "nordpool" "tplink_tapo" "tplink" ];
      customComponents = with pkgs.home-assistant-custom-components;
        [ adaptive_lighting ];
      customLovelaceModules =
        with unstable.home-assistant-custom-lovelace-modules; [
          light-entity-card
          mushroom
          button-card
          apexcharts-card
        ];
      openFirewall = true;
      config = {
        default_config = { };
        lovelace.mode = "yaml";
        http = {
          server_host = "0.0.0.0";
          server_port = config.home-assistant.port;
          use_x_forwarded_for = true;
          trusted_proxies = [ "127.0.0.1" "::1" ];
        };
        script = "!include scripts.yaml";
        # automation = "!include automations.yaml";
        scene = "!include scenes.yaml";

        template = [{
          trigger = [
            # This sensor will update whenever our automation fires this custom event
            {
              platform = "event";
              event_type = "nordpool_prices_update";
            }
          ];
          sensor = [{
            name = "Nord Pool Prices DK2 NEW!";
            unique_id = "nord_pool_prices_dk2_template";
            # The state will be the price for the current hour
            state = "{{ trigger.event.data.prices[now().hour].price }}";
            unit_of_measurement = "DKK/kWh";
            attributes = {
              # We store the full list of today's prices in an attribute
              today_prices = "{{ trigger.event.data.prices }}";
            };
          }];
        }];

        automation = [{
          alias = "Fetch and Update Nord Pool Prices Daily";
          id = "fetch_and_update_nord_pool_prices_daily";
          trigger = {
            # Runs every day a few minutes after the prices are available
            platform = "time";
            at = "01:05:00";
          };
          action = [
            # This is your service call to get the data
            {
              service = "nordpool.get_prices_for_date";
              data = {
                config_entry = "01K793EWHQ9HDARJR3PX5F67A5";
                currency = "DKK";
                date = "{{ now().date() }}";
              };
              response_variable = "nord_pool_out";
            }
            # This fires the custom event that our sensor is listening for
            {
              event = "nordpool_prices_update";
              event_data = {
                # We pass the list of prices from the DK2 area
                prices = "{{ nord_pool_out.DK2 }}";
              };
            }
          ];
        }];

      };
    };
  };
}
