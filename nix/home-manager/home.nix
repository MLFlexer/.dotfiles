{
  config,
  pkgs,
  ...
}: {
  home = {
    stateVersion = "22.11";
    homeDirectory = "/home/mlflexer";
    username = "mlflexer";
    packages = with pkgs; [
      cowsay
    ];

  };

  nixpkgs.config = {
    allowUnfree = true;
    # allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
