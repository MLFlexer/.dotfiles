{ pkgs
, pkgs_unstable
, ...
}:
{
  home.packages = (with pkgs; [
    # stable
    age
    atuin
    comma
    eza
    fd
    fzf
    lazygit
    python3
    ripgrep
    ripgrep-all
    zoxide
  ]) ++ (with pkgs_unstable; [
    # unstable
    yazi
  ]);
}
