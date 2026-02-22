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
          light = false;
          background-color = "235 24 16";
          primary-color = "280 65 75";
          negative-color = "350 75 65";
          contrast-multiplier = 1.2;
          text-saturation-multiplier = 0.8;
        };

        branding.hide-footer = true;

        pages = [
          {
            name = "Startpage";
            width = "wide";
            center-vertically = true;
            head-widgets = [
              {
                type = "search";
                autofocus = true;
                search-engine = "https://www.qwant.com/?q={QUERY}";
                bangs = [
                  {
                    title = "Youtube";
                    shortcut = "!yt";
                    url = "https://www.youtube.com/results?search_query={QUERY}";
                  }
                  {
                    title = "Nix Packages";
                    shortcut = "!np";
                    url = "https://search.nixos.org/packages?query={QUERY}";
                  }
                  {
                    title = "Nix Options";
                    shortcut = "!npo";
                    url = "https://search.nixos.org/options?query={QUERY}";
                  }
                  {
                    title = "Home Manager Options";
                    shortcut = "!hm";
                    url = "https://home-manager-options.extrawurst.org/?query={QUERY}";
                  }
                  {
                    title = "NixOS Wiki";
                    shortcut = "!nw";
                    url = "https://wiki.nixos.org/w/index.php?search={QUERY}";
                  }
                  {
                    title = "GitHub";
                    shortcut = "!gh";
                    url = "https://github.com/search?q={QUERY}";
                  }
                  {
                    title = "Google";
                    shortcut = "!g";
                    url = "https://www.google.com/search?q={QUERY}";
                  }
                  {
                    title = "Google Maps";
                    shortcut = "!maps";
                    url = "https://www.google.com/maps?q=hello";
                  }
                  {
                    title = "DuckDuckGo";
                    shortcut = "!ddg";
                    url = "https://duckduckgo.com/?q={QUERY}";
                  }
                  {
                    title = "Reddit";
                    shortcut = "!r";
                    url = "https://www.reddit.com/search/?q={QUERY}";
                  }
                  {
                    title = "Perplexity";
                    shortcut = "!px";
                    url = "https://www.perplexity.ai/search?q={QUERY}";
                  }
                ];
              }
            ];
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "to-do";
                  }
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "weather";
                        location = "Copenhagen, Denmark";
                        units = "metric";
                        hour-format = "24h";
                      }

                      {
                        "$include" = ./widgets/community/weather_7days.yml;
                      }
                      {
                        "$include" = ./widgets/community/air_quality.yml;
                      }
                    ];
                  }
                  {
                    type = "calendar";
                    first-day-of-week = "monday";
                  }

                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        links = [
                          {
                            title = "Github";
                            url = "https://github.com/";
                          }
                          {
                            title = "YouTube";
                            url = "https://www.youtube.com/";
                          }
                          {
                            title = "Reddit";
                            url = "https://www.reddit.com/";
                          }
                          {
                            title = "Gmail";
                            url = "https://mail.google.com/mail/u/0/";
                          }
                        ];
                      }
                      {
                        links = [
                          {
                            title = "KU-Net";
                            url = "https://kunet.ku.dk/";
                          }
                          {
                            title = "KU-Mail";
                            url = "https://webmail.ku.dk";
                          }
                          {
                            title = "ssd_os";
                            url = "https://github.com/OpenSSD-V/ssd_os";
                          }
                        ];
                      }
                    ];
                  }
                  {
                    "$include" = ./widgets/community/github_notification.yml;
                  }
                  # {
                  #   "$include" = ./widgets/community/github_personal_repos.yml;
                  # }
                  # {
                  #   type = "releases";
                  #   show-source-icon = true;
                  #   repositories = [
                  #     "go-gitea/gitea"
                  #     "jellyfin/jellyfin"
                  #     "glanceapp/glance"
                  #     "codeberg:redict/redict"
                  #     "gitlab:fdroid/fdroidclient"
                  #     "dockerhub:gotify/server"
                  #   ];
                  # }
                  {
                    type = "rss";
                    title = "News";
                    style = "horizontal-cards";
                    feeds = [
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/regionale/kbh";
                        title = "DR: KBH";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/regionale/sjaelland";
                        title = "DR: Sjælland";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/vejret";
                        title = "DR: Vejret";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/sporten";
                        title = "DR: Sporten";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/politik";
                        title = "DR: Politik";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/penge";
                        title = "DR: Penge";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/udland";
                        title = "DR: Udland";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/indland";
                        title = "DR: Inland";
                      }
                      {
                        url = "https://www.dr.dk/nyheder/service/feeds/senestenyt";
                        title = "DR: Seneste Nyt";
                      }
                      {
                        url = "https://feeds.services.tv2.dk/api/feeds/nyheder/rss";
                        title = "TV2 Nyheder";
                      }
                    ];
                  }
                ];
              }
            ];
          }
          {
            name = "Monitor";
            width = "wide";
            center-vertically = true;
            columns = [
              {
                size = "full";
                widgets = [
                  monitor_widgets.core_stack
                  monitor_widgets.arr_stack
                  {
                    type = "server-stats";
                    servers = [
                      {
                        type = "local";
                        name = "Services";
                        mountpoints = {
                          "/mnt/usbdrive2".name = "HDD";
                        };
                      }
                    ];
                  }
                  monitor_widgets.adguard_status
                  {
                    "$include" = ./widgets/community/sonarr_releases.yml;
                  }
                  {
                    "$include" = ./widgets/community/radarr_releases.yml;
                  }
                ];
              }
            ];
          }

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
