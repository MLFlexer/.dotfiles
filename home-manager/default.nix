{ inputs, ... }:
{
  laptop = (import ./laptop.nix { inherit inputs; }).config;
  rpi5 = (import ./rpi5.nix { inherit inputs; }).config;
}
