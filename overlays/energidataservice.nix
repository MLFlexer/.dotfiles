self: super: {
  home-assistant-custom-components = super.home-assistant-custom-components // {
    energidataservice = super.callPackage
      ./home-assistant-custom-components/energidataservice/package.nix {
        inherit (super)
          lib fetchFromGitHub buildHomeAssistantComponent home-assistant;
      };
  };
}

