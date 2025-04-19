{ lib, ... }: {

  options = {
    user = lib.mkOption { default = "mlflexer"; };
    config_dir = lib.mkOption {
      default = "/home/mlflexer/repos/.dotfiles/home-manager/config";
    };
  };
  imports = [ ./cli_tools.nix ./cli_extra.nix ./configs/default.nix ];

}
