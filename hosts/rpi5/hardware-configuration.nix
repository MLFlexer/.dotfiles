{
  hardware = {
    # bluetooth.enable = true;

    raspberry-pi.config.all.base-dt-params = {
      # bluetooth
      krnbt = {
        enable = true;
        value = "on";
      };
    };
  };
}
