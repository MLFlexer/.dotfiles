{ inputs, ... }: {
  # Laptop profile
  laptop = import ./laptop { inherit inputs; };
  # Raspberry Pi 5 profile
  rpi5 = import ./rpi5 { inherit inputs; };
  # other profiles ...
}
