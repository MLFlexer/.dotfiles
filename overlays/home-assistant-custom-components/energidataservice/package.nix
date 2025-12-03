{ lib, buildHomeAssistantComponent, fetchFromGitHub, home-assistant, }:

buildHomeAssistantComponent rec {
  owner = "MTrab";
  domain = "energidataservice";
  version = "unstable-2025-10-10";

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "energidataservice";
    rev = "master";
    hash = "sha256-PAFCPAZmxJhY1opZsuRsGZLPybZhGoHZuAMtlVSWYwM=";
  };

  dependencies = with home-assistant.python.pkgs; [
    async_retrying
    CurrencyConverter
  ];

  nativeCheckInputs = [ home-assistant ]
    ++ (home-assistant.getPackages "stream" home-assistant.python.pkgs);

  meta = with lib; {
    description =
      "Home Assistant integration for Energi Data Service (electricity prices in Denmark)";
    homepage = "https://github.com/MTrab/energidataservice";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

