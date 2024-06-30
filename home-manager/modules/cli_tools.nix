{ pkgs
, pkgs_unstable
, ...
}:
{
  home.packages = (with pkgs; [
    # stable
    atuin
    comma
    fd
    fzf
    lazygit
    ripgrep
    ripgrep-all
    python3
    zoxide
    eza
  ]) ++ (with pkgs_unstable; [
    # unstable
    yazi
  ]);
}
