{ pkgs, config, lib, pkgs_unstable, ... }: {
  options = {
    cli_extra.enable = lib.mkEnableOption "Enables extra cli tools";
  };

  config = lib.mkIf config.cli_extra.enable {

    home.packages = (with pkgs; [
      # broot
      # choose
      # difftastic
      # du-dust
      dust
      # erdtree
      # fselect
      # fx
      # grex
      ntfy-sh
      # procs
      # sd
      tealdeer
      gnumake
      # xclip
      # xsv

      act
      ffmpeg
      pandoc
      hyperfine
      texliveMedium
    ]) ++ (with pkgs_unstable;
      [
        # ollama

        # nodejs
        # yarn
        # rustup
        # ghc # Haskell
        # go
        # haskell-language-server
        # nodejs_20
        # zig
        # nixd
        # nixpkgs-fmt
        # asm-lsp
        # lua-language-server
        # nil
      ]);
  };
}
