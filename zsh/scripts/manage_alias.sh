#!/bin/bash -i

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-help" ]; then # help argument
	printf "\n"
	printf "\033[1m  mal - manage your aliases\n"
	printf "\n"
	printf "\033[32m  Add alias\n"
	printf "\033[34m      mal {name} {command}\n"
	printf "\033[34m      mal {name} \"{command1} {command2}\"\n"
	printf "\n"
	printf "\033[31m  Delete alias from fzf list\n"
	printf "\033[34m      mal -d\n"
	printf "\n"
	printf "\033[31m  Delete alias by alias name\n"
	printf "\033[34m      mal -da {name}\n"
	printf "\n"
	printf "\033[32m  Show help\n"
	printf "\033[34m      mal -h\n"
	printf "\033[34m      mal -help\n"
	printf "\033[34m      mal --help\n"
	printf "\n"
	return 0
fi

aliases_file=$HOME/.config/zsh/.aliases
if [ $1 = -d ]; then
	alias_to_delete=$(cut -d' ' -f2- $aliases_file | fzf)
	if [ $? -eq 130 ]; then
		return 1
	fi
	echo Deleted alias: $alias_to_delete
	sed -i "/$alias_to_delete/d" $aliases_file
	alias_name="${alias_to_delete%%=*}"
	unalias $alias_name
elif [ $1 = -da ]; then
	alias_to_delete=$2
	line_with_alias=$(grep "$2=" $aliases_file)
	if [ -z "$line_with_alias" ]; then
		echo No alias with the name $2 found.
		return 2
	fi
	echo Deleted alias: $alias_to_delete
	sed -i "/$alias_to_delete=/d" $aliases_file
	unalias $alias_to_delete
else
	line_with_alias=$(grep "$1=" $aliases_file)
	if [ ! -z "$line_with_alias" ]; then
		echo Alias found: $line_with_alias
		echo Remove alias by using the -d flag.
		return 3
	fi

	lh="alias $1"
	rh=\"$2\"
	alias_str="$lh=$rh"

	echo $alias_str >>$aliases_file
	echo added \"$alias_str\" to .aliases
fi

source $HOME/.config/zsh/.aliases
