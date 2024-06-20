

{
  nix = {
    settings = {
      substituters = [
        "https://raspberry-pi-nix.cachix.org"
      ];
      trusted-public-keys = [
        "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
      ];
    };
  };
}
