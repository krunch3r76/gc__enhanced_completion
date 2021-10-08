#!/bin/bash
# install.sh
# installs bash completions to $HOME/.local
# and updates .bashrc


# ensure actions are non destructive
set -o noclobber

# check command line
if [[ $# != 0 ]]; then
	echo "Usage: $0"
	exit 1
fi


###########helpers########################
GREEN="\e[0;32m";YELLOW="\e[0;93m";BOLD="\e[1m";RED="\e[0;31m";YELLOWBOLD="$YELLOW$BOLD"
BLINK="\e\033[5m"
ECHO_COLOR() {
	COLOR=$1
	MSG=$2
	END="\n"
	if [[ $3 ]]; then
		END=""
	fi
	echo -ne "${COLOR}${MSG}${NOCOLOR}$END"
}
NOCOLOR="\e[0m"
###########################################


SOURCE_FILE=gc_golem

# ensure there is a file to install
if [[ ! -e $SOURCE_FILE ]]; then
	ECHO_COLOR $RED "the script file is not in the directory, so it cannot be installed!"
	exit 1
fi

SOURCE_VERSION=$(grep "# tag:" $SOURCE_FILE | sed -E 's/^[^:]*[:][[:space:]]*(.*)[[:space:]]*$/\1/' )
echo "installing target version '$SOURCE_VERSION'"

DEST_FILEPATH=$HOME/.local/share/bash-completion/completions/$SOURCE_FILE


echo -n "target version already installed..."
if [[ -e $DEST_FILEPATH ]]; then
	DEST_EXISTS=1
	MD5_LOCAL=$(md5sum $SOURCE_FILE | cut -f1 -d" ")
	MD5_TARGET=$(md5sum $DEST_FILEPATH | cut -f1 -d" ")
	if [[ $MD5_LOCAL == $MD5_TARGET ]]; then
		SOURCE_SAME_AS_DEST=1
	fi
fi

if [[ $SOURCE_SAME_AS_DEST == 1 ]]; then
	ECHO_COLOR $BOLD "YES"
else
	ECHO_COLOR $BOLD "...NO"
	INSTALL_CMD="install -m644 $SOURCE_FILE -D $DEST_FILEPATH"
	echo -n "installing to $DEST_FILEPATH..."
	$INSTALL_CMD 2>/dev/null
	if [[ $? == 0 ]]; then
		ECHO_COLOR $GREEN "OK"
	else
		ECHO_COLOR $RED "FAILED"
		exit 2
	fi
fi


echo -n "bashrc contains source invocation..."
BASHRC_LINE="source \$HOME/.local/share/bash-completion/completions/$SOURCE_FILE"

IS_SOURCED_FROM_BASHRC=$(egrep ^source $HOME/.bashrc | grep $SOURCE_FILE 2>/dev/null)
if [[ -z $IS_SOURCED_FROM_BASHRC ]]; then
	unset MODIFIED_BASHRC # guarantees it is not set
	ECHO_COLOR $YELLOW NO
	ECHO_COLOR $YELLOW "---ACTION REQUIRED---"
	echo "Your .bashrc needs modification to load the installed completion engine automatically."
	echo "You can update your .bashrc by appending the following line to it:"
	echo -e "\t$BASHRC_LINE"
	ECHO_COLOR $BOLD "Would you like me to append the line to your .bashrc for you? [n] " 0
	read -n1
	echo ""
	if [[ "$REPLY" == @(y|Y) ]]; then
		echo -en "\nappending source invocation to $HOME/.bashrc..."
		echo $BASHRC_LINE >> $HOME/.bashrc
		if [[ $? == 0 ]]; then
			ECHO_COLOR $GREEN OK
			MODIFIED_BASHRC=1
		else
			echo -e "FAILED"
		fi
	fi
else
	ECHO_COLOR $GREEN "YES"
fi

if [[ ! -z $IS_SOURCED_FROM_BASHRC && $SOURCE_SAME_AS_DEST == 1 ]]; then
	ECHO_COLOR $BOLD "The installation was already up to date."
else
	ECHO_COLOR $YELLOWBOLD "\n---POST INSTALLATION ACTIONS---"
	ECHO_COLOR $BOLD "the installation was successful, " 0
	if [[ ! $MODIFIED_BASHRC ]]; then
		echo "to activate the completion engine:"
		echo "$(ECHO_COLOR $BOLD 1)) $BASHRC_LINE"
		echo "$(ECHO_COLOR $BOLD 2)) echo '$BASHRC_LINE' >> \$HOME/.bashrc"
	else
		echo "to activate the completion engine either run: "
		echo "$(ECHO_COLOR $BOLD 1)) $BASHRC_LINE"
		echo "or $(ECHO_COLOR $BOLD 2)) start a new terminal session"
	fi
fi

