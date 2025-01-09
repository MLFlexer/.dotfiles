{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    allowDHCP = true;
    port = 5000;
    settings = {
        http.address = "0.0.0.0:5000";
      };
  };
}
