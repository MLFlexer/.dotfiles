{ inputs, ... }:
{
  # Laptop profile
  laptop = (import ./laptop {inherit inputs;}).laptop; # TODO: fix this such that dot laptop is removed
  # Raspberry Pi 5 profile
  rpi5 = (import ./rpi5 {inherit inputs;}).rpi5; # TODO: fix this such that dot rpi5 is removed
  rpi-test = (import ./rpi-test {inherit inputs;}).rpi5; # TODO: fix this such that dot rpi5 is removed
  # other profiles ...
}
