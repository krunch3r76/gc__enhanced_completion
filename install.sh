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
LOCAL_PATH="${PWD}/${SOURCE_FILE}"
TMP_PATH="/tmp/${SOURCE_FILE}"

# Determine the path to use for the script
if [[ -e "$LOCAL_PATH" ]]; then
    SCRIPT_PATH="$LOCAL_PATH"
elif [[ ! -f "$TMP_PATH" ]]; then
    echo "Downloading $SOURCE_FILE from GitHub..."
    curl -L https://github.com/krunch3r76/gc__enhanced_completion/raw/main/gc_golem \
        -o "$TMP_PATH" || { ECHO_COLOR $RED "ERROR: Failed to download $SOURCE_FILE." ; exit 1; }
    SCRIPT_PATH="$TMP_PATH"
else
    SCRIPT_PATH="$TMP_PATH"
fi

extract_version_from_file() {
    local file="$1"
    grep -m 1 '^# _version:' "$file" | sed -E 's/^#_ version:[[:space:]]*(.*)[[:space:]]*$/\1/'
}

SOURCE_VERSION=$(extract_version_from_file "$SCRIPT_PATH")
echo "🔄 Installing target version '$SOURCE_VERSION'..."

DEST_DIR="$HOME/.local/share/bash-completion/completions"
DEST_FILEPATH="${DEST_DIR}/${SOURCE_FILE}"
mkdir -p "$DEST_DIR"

DEST_EXISTS=0
DEST_VERSION=""

if [[ -e $DEST_FILEPATH ]]; then
    DEST_EXISTS=1
    DEST_VERSION=$(extract_version_from_file "$DEST_FILEPATH")
fi

if [ -z "$DEST_EXISTS" ] || [ "$SOURCE_VERSION" != "$DEST_VERSION" ]; then
    cp "$SCRIPT_PATH" "$DEST_FILEPATH"
    echo "✅ Successfully installed version '$SOURCE_VERSION'."
else
    echo "👍 No update needed, version '$SOURCE_VERSION' already installed."
fi

BASHRC_LINE="source \$HOME/.local/share/bash-completion/completions/${SOURCE_FILE}"
IS_SOURCED_FROM_BASHRC=$(grep -E "^[[:space:]]*source[[:space:]]+.*${SOURCE_FILE}" "$HOME/.bashrc" 2>/dev/null)

echo "🔍 Checking if .bashrc "
echo -n "    already sources the completion script... "

if [[ -n $IS_SOURCED_FROM_BASHRC ]]; then
    ECHO_COLOR $YELLOWBOLD "YES - no need to update"
    MODIFIED_BASHRC=1
else
    ECHO_COLOR $YELLOW "NO"
    ECHO_COLOR $YELLOW "---ACTION REQUIRED---"
    echo "Your .bashrc needs modification to load the installed completion engine automatically."
    echo "You can update your .bashrc by appending the following line to it:"
    echo -e "\t$BASHRC_LINE"
    ECHO_COLOR $BOLD "Would you like me to append the line to your .bashrc for you? [n] " 0
    read -n1
    echo ""
    if [[ "$REPLY" == @(y|Y) ]]; then
        echo -en "\nappending source invocation to $HOME/.bashrc..."
        echo "$BASHRC_LINE" >>"$HOME/.bashrc"
        if [[ $? -eq 0 ]]; then
            ECHO_COLOR $GREEN "OK"
            MODIFIED_BASHRC=1
        else
            echo -e "FAILED"
        fi
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
```
