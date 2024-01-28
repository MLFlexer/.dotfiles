{ pkgs, erlang_26 }:

pkgs.stdenv.mkDerivation {
    name = "erlang-quickcheck";
    src = pkgs.fetchurl {
      url = "http://quviq.com/downloads/eqcR25-2.02.0.zip";
      sha256 = "0i33y81g5h0g2zi1drfkvqc3wiwacjkn12mix6hw1vzjv56x3v4k";
    };

    buildInputs = [ erlang_26 ];
    nativeBuildInputs = with pkgs; [
      unzip
    ];

    wrapper = pkgs.writeScriptBin "erl" ''
      #!/bin/sh
      exec $erlang_26/bin/erl -pa $DIR/eqcR25-2.02.0/ebin "\$@"
    '';

    buildPhase = ''
      DIR=$out/lib/erlang/lib/eqcR25-2.02.0
      mkdir -p $DIR
      unzip $src -d $DIR
      mv $DIR/Quviq\ QuickCheck\ Mini\ version\ 2.02.0\ for\ OTP\ 25/eqc-2.02.0/* $DIR
      rm -rdf $DIR/Quviq\ QuickCheck\ Mini\ version\ 2.02.0\ for\ OTP\ 25
      mv $wrapper $out/bin/erl_wrapper
    '';


  }
