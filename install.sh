#!/bin/bash

if [ -d "$HOME/old_dotfiles" ]; then
  echo "removing $HOME/old_dotfiles/"
  rm -rfd "$HOME/old_dotfiles"
fi

mkdir $HOME/old_dotfiles
back_up_dir="$HOME/old_dotfiles"

# symlink dotfiles:
declare -a dot_arr
dot_arr=(".gitconfig" ".zshrc" ".tmux.conf")

for file in ${dot_arr[@]}
do
  if [ -f "$HOME/$file" ]; then
    echo "moving $file to $HOME/old_dotfiles/"
    mv $HOME/$file $back_up_dir/$file
  fi
  ln -s $PWD/$file $HOME/$file
done

# symlink .config-directories:

mkdir $back_up_dir/.config

declare -a conf_arr
conf_arr=("alacritty" "nvim")

for dir in ${conf_arr[@]}
do
  if [ -d "$HOME/.config/$dir/" ]; then
    echo "moving $dir to $HOME/old_dotfiles/.config/"
    mv $HOME/.config/$dir $back_up_dir/.config/$dir
  fi
  ln -s $PWD/$dir $HOME/.config/$dir
done
