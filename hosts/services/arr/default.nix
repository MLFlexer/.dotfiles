# NOTE: Use mullvad socks5 proxy for all services
# IP: 10.64.0.1
# PORT: 1080

{ lib, config, ... }:

{
  imports = [ ./contained.nix ./jelly.nix ];

  options = {
    arr.enable = lib.mkEnableOption "Enables arr-stack";
    arr.data_dir = lib.mkOption { default = "/data"; };
    arr.group = lib.mkOption { default = "arr"; };
  };

  config = lib.mkIf config.arr.enable {
    users.groups.${config.arr.group} = {
      name = config.arr.group;
      gid = 6969;
    };

    # TODO: mkdir if container
    system.activationScripts.setDataPermissions = ''
      mkdir -p /mnt/arr

      chown -R root:${config.arr.group} ${config.arr.data_dir}
      chmod -R 2777 ${config.arr.data_dir}
    '';

  };
}
