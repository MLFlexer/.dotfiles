{ lib, config, ... }:
let
  monitor_widgets = import ./widgets/monitor.nix { inherit config lib; };
in
{

  options = {
    glance.enable = lib.mkEnableOption "Enables glance";
    glance.port = lib.mkOption { default = 5678; };
    glance.domain = lib.mkOption { default = "dashboard.mlflexer.online"; };
    glance.env_file = lib.mkOption {
      default = "/home/mlflexer/repos/.dotfiles/hosts/services/glance/.env";
    };
  };

  config = lib.mkIf config.glance.enable {
    services.glance = {
      enable = true;
      settings = {
        server = {
          port = config.glance.port;
          bind_address = "0.0.0.0";
          proxied = true;
        };

        auth = {
          secret-key = "\${GLANCE_SECRET_KEY}";
          users = {
            admin = {
              password-hash = "$2a$10$llbIbnS.fa5FuHH7QMvbBeSYjeU.UNkjgPRVgLRaxsk3Y.0TJDTO6";
            };
          };
        };

        theme = {
          light = true;
          background-color = "28 40 77";
          primary-color = "155 100 20";
          negative-color = "0 100 60";
          contrast-multiplier = 1.1;
          text-saturation-multiplier = 0.5;
        };

        pages = [
          {
            name = "Startpage";
            width = "slim";
            hide-desktop-navigation = true;
            center-vertically = true;
            columns = [
              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    autofocus = true;
                    search-engine = "https://duckduckgo.com/?q={QUERY}";
                    bangs = [
                      # TODO
                    ];
                  }
                  # Group
                  monitor_widgets.core_stack
                  monitor_widgets.arr_stack
                  monitor_widgets.adguard_status
                  {
                    type = "weather";
                    location = "London, United Kingdom";
                    units = "metric";
                    hour-format = "12h";
                  }
                  {
                    type = "to-do";
                  }
                  {
                    type = "releases";
                    show-source-icon = true;
                    repositories = [
                      "go-gitea/gitea"
                      "jellyfin/jellyfin"
                      "glanceapp/glance"
                      "codeberg:redict/redict"
                      "gitlab:fdroid/fdroidclient"
                      "dockerhub:gotify/server"
                    ];
                  }
                  {
                    type = "server-stats";
                    servers = [
                      {
                        type = "local";
                        name = "Services";
                      }
                    ];
                  }
                  {
                    type = "rss";
                    title = "News";
                    style = "horizontal-cards";
                    feeds = [
                      {
                        url = "https://feeds.bloomberg.com/markets/news.rss";
                        title = "Bloomberg";
                      }
                      {
                        url = "https://moxie.foxbusiness.com/google-publisher/markets.xml";
                        title = "Fox Business";
                      }
                      {
                        url = "https://moxie.foxbusiness.com/google-publisher/technology.xml";
                        title = "Fox Business";
                      }
                    ];
                  }
                ];
              }
            ];
          }

          # { "$include" = ./home.yml; }
          { "$include" = ./videos.yml; }
          { "$include" = ./monitor.yml; }
        ];

      };
    };

    systemd.services.glance = {
      serviceConfig = {
        EnvironmentFile = lib.mkForce config.glance.env_file;
      };
    };
  };

}
