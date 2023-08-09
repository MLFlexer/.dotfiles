{ config, lib, pkgs, unstable, user, ... }:

{
  imports = [
    (import ../../home-manager/packages.nix)
    (import ../../home-manager/sym_conf.nix)
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
  };
}
