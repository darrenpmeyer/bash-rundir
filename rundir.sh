#!/usr/bin/env bash
set -uo pipefail

# Print usage message and exit
usage() {
	>&2 cat <<USAGE
Usage: ${0:-} DIR

    DIR    directory containing scripts to run
USAGE

exit ${1:-1}
}

# Write to stderr
err() {
	>&2 echo "$@"
}

BOLD="$(tput bold)"
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
RESET="$(tput sgr0)"


#----

[[ -n "${1:-}" ]] || usage
directory="$1"
shift


if ! [[ -d "$directory" ]]
then
	err "'$directory' isn't a directory"
	exit 1
fi


# TODO command-line switch for 'dry run'
# TODO command-line switch for 'recursive' -- recursive is default

#----

cwd="$PWD"

for script in $(find "$directory" -type f -or -type l -name "*.sh" -perm +0111 | sort)
do
	# TODO refuse to run myself to avoid infinite recurseion
	# TODO skip marked disabled (how should I do that?
	err -e "\n${BOLD}======${RESET}\n= RUN: [$script] $@"

	while [[ -L "$script" ]]
	do
		script="$(readlink -n "$script")"
		err "${BOLD} -> redirect: ${RESET}$script"
	done

	err "------"
	("$script" "$@")
   err -e "\n------"

	if [ $? != 0 ]
	then
		COLOR="$RED"
	else
		COLOR="$GREEN"
	fi	
	err -e "${COLOR}= EXIT $? ${RESET}[$script]\n"

	# restore before next run
	cd "$cwd"
	tput sgr0
done

