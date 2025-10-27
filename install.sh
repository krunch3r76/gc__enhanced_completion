#!/usr/bin/env bash
# install.sh
# Installs bash completions to $HOME/.local and updates .bashrc

set -o noclobber
set -e

GREEN="\e[0;32m"
YELLOW="\e[0;93m"
BOLD="\e[1m"
RED="\e[0;31m"
YELLOWBOLD="$YELLOW$BOLD"
BLINK="\e\033[5m"
NOCOLOR="\e[0m"

_read_opts="-r -u 2"

ECHO_COLOR() {
	local COLOR=$1
	local MSG=$2
	local END="\n"
	[[ $3 ]] && END=""
	echo -ne "${COLOR}${MSG}${NOCOLOR}${END}"
}

if [[ $# -ne 0 ]]; then
	echo "Usage: $0"
	exit 1
fi

SOURCE_FILE="gc_golem"
TMP_FILE="/tmp/${SOURCE_FILE}"
LOCAL_FILE="${PWD}/${SOURCE_FILE}"

if [[ ! -e $LOCAL_FILE && ! -e $TMP_FILE ]]; then
	curl https://raw.githubusercontent.com/krunch3r76/gc__enhanced_completion/main/${SOURCE_FILE} >${TMP_FILE}
fi

if [[ ! -e $LOCAL_FILE && ! -e $TMP_FILE ]]; then
	ECHO_COLOR $RED "ERROR: Neither $LOCAL_FILE nor $TMP_FILE exists."
	exit 1
fi

SOURCE_FILE_TO_USE=$LOCAL_FILE
[[ -e $TMP_FILE ]] && SOURCE_FILE_TO_USE=$TMP_FILE

extract_version_from_file() {
	local file="$1"
	grep -m 1 '^# *version:' "$file" | sed -E 's/^# *version:[[:space:]]*(.*)[[:space:]]*$/\1/'
}

SOURCE_VERSION=$(extract_version_from_file "$SOURCE_FILE_TO_USE")

echo "🔄 Installing target version '$SOURCE_VERSION'..."

DEST_DIR="$HOME/.local/share/bash-completion/completions"
DEST_FILEPATH="$DEST_DIR/$SOURCE_FILE"

mkdir -p "$DEST_DIR"

DEST_EXISTS=0
SOURCE_SAME_AS_DEST=0
DEST_VERSION=""

if [[ -e $DEST_FILEPATH ]]; then
	DEST_EXISTS=1
	DEST_VERSION=$(extract_version_from_file "$DEST_FILEPATH")
fi

if [ -z "$DEST_EXISTS" ] || [ "$SOURCE_VERSION" != "$DEST_VERSION" ]; then
	cp "$SOURCE_FILE_TO_USE" "$DEST_FILEPATH"
	echo "✅ Successfully installed version '$SOURCE_VERSION'"
	echo "    to $DEST_FILEPATH."
	NEW_VERSION_INSTALLED=true
else
	echo "👍 No update needed, version '$SOURCE_VERSION'"
	echo "    at $DEST_FILEPATH"
	echo "    was previously installed."
fi

BASHRC_LINE="source \$HOME/.local/share/bash-completion/completions/${SOURCE_FILE}"
IS_SOURCED_FROM_BASHRC=$(fgrep "$SOURCE_FILE" "$HOME/.bashrc") || true

echo "🔍 Checking if .bashrc "
echo -n "    already sources the completion script... "

if [[ -n $IS_SOURCED_FROM_BASHRC ]]; then
	ECHO_COLOR $YELLOWBOLD "YES - no need to update"
	if [[ $NEW_VERSION_INSTALLED ]]; then
		ECHO_COLOR $YELLOWBOLD "    source ~/.bashrc or open a new terminal window to use it!"
	fi
	MODIFIED_BASHRC=1
else
	ECHO_COLOR $YELLOW "NO"
	ECHO_COLOR $YELLOW "---ACTION REQUIRED---"
	echo "Your .bashrc needs modification to load the installed completion engine automatically."
	echo "You can update your .bashrc by appending the following line to it:"
	echo -e "\t$BASHRC_LINE"
	ECHO_COLOR $BOLD "Would you like me to append this to your .bashrc for you? [Y/n] " 0
	read ${_read_opts} -n1
	echo ""
	if [[ "$REPLY" != @(n|N) ]]; then
		echo -en "\nappending source invocation to $HOME/.bashrc..."
		echo "$BASHRC_LINE" >>"$HOME/.bashrc"
		if [[ $? -eq 0 ]]; then
			ECHO_COLOR $GREEN "OK"
			MODIFIED_BASHRC=1
		else
			echo -e "FAILED"
		fi
	else
		echo -e "\n💾✨ No problem, but be sure to add the above line your .bashrc to unlock the power!"
	fi
fi

if [[ -z $IS_SOURCED_FROM_BASHRC && $DEST_EXISTS -eq 0 ]]; then
	echo
	ECHO_COLOR $YELLOWBOLD "\n---POST INSTALLATION ACTIONS---"
	ECHO_COLOR $BOLD "the installation was successful, " 0
	if [[ -z $MODIFIED_BASHRC ]]; then
		echo "to activate the completion engine:"
		echo "$(ECHO_COLOR $BOLD 1)) $BASHRC_LINE"
		echo "$(ECHO_COLOR $BOLD 2)) echo '$BASHRC_LINE' >> \$HOME/.bashrc"
	else
		echo "to activate the completion engine either run: "
		echo "$(ECHO_COLOR $BOLD 1)) $BASHRC_LINE"
		echo "or $(ECHO_COLOR $BOLD 2)) start a new terminal session"
	fi
fi

# Clean up temporary file if it was downloaded
if [[ "$SCRIPT_PATH" == "$TMP_PATH" && -e "$TMP_PATH" ]]; then
	rm -f "$TMP_PATH"
fi
