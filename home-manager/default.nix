{ inputs, ... }: {
  laptop = import ./laptop.nix { inherit inputs; };
  desktop = import ./desktop.nix { inherit inputs; };
  rpi5 = import ./rpi5.nix { inherit inputs; };
}
