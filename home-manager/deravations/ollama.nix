{ pkgs }:

pkgs.stdenv.mkDerivation {
    name = "ollama";
    version = "0.1.17";
    src = pkgs.fetchurl {
      url = "https://github.com/jmorganca/ollama/releases/download/v0.1.17/ollama-linux-amd64";
      sha256 = "sha256-t33uwWlqVJC7lCN4n/4nRxPG1ipnGc31Cxr9lR4jxws=";
    };

    unpackPhase = "";

    buildPhase = ''
    mkdir -p $out/ollama
    cp $src $out/ollama/ollama-linux-amd64
    '';


  }
