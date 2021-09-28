#!/usr/bin/bash
# install.sh
# installs bash completions to $HOME/.local
# and updates .bashrc

if [[ $# != 0 ]]; then
	echo "Usage: $0"
	exit 1
fi

# install -m644 gc_golem -D /home/krunch3r/.local/share/bash-completion/completions/gc_golem
GREEN="\e[0;32m";YELLOW="\e[0;93m";BOLD="\e[1m";RED="\e[0;31m";YELLOWBOLD="$YELLOW$BOLD"
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

INSTALL_FILE=gc_golem

if [[ ! -e $INSTALL_FILE ]]; then
	ECHO_COLOR $RED "the script file is not in the directory, so it cannot be installed!"
	exit
fi

TARGET_PATH=$HOME/.local/share/bash-completion/completions/$INSTALL_FILE
INSTALL_CMD="install -m644 $INSTALL_FILE -D $TARGET_PATH"

MD5_LOCAL=$(md5sum $INSTALL_FILE | cut -f1 -d" ")
MD5_TARGET=
if [[ -e $TARGET_PATH ]]; then
	MD5_TARGET=$(md5sum $TARGET_PATH | cut -f1 -d" ")
fi


GREPPED=$(egrep ^source $HOME/.bashrc | grep $INSTALL_FILE 2>/dev/null)

set noclobber
# TAG=$(grep "# tag:" $INSTALL_FILE | cut -f2 -d ":" | sed -E 's/^[[:space:]]*([^[:space:]])[[:space:]]*$/\1/' )
TAG=$(grep "# tag:" $INSTALL_FILE | sed -E 's/^[^:]*[:][[:space:]]*(.*)[[:space:]]*$/\1/' )
echo "installing target version '$TAG'"
echo -n "target version already installed..."
ALREADY_INSTALLED=0
if [[ -e $TARGET_PATH && ($MD5_LOCAL == $MD5_TARGET) ]]; then
	ECHO_COLOR $BOLD "YES" 0
	echo -n "...no update required"
	if [[ ! GREPPED ]]; then
		ECHO_COLOR $YELLOWBOLD " BUT NOT AUTO-LOADED"
	else
		echo ""
	fi
	ALREADY_INSTALLED=1
else
	ECHO_COLOR $BOLD "NO" 0
	echo " or update required"
fi

if [[ $ALREADY_INSTALLED == 0 ]]; then
	echo -n "installing to $TARGET_PATH..."
	$INSTALL_CMD 2>/dev/null
	if [[ $? == 0 ]]; then
		ECHO_COLOR $GREEN "OK"
	else
		ECHO_COLOR $RED "FAILED"
		exit
	fi
fi

echo -n "bashrc contains source invocation..."
BASHRC_LINE="source \$HOME/.local/share/bash-completion/completions/$INSTALL_FILE"
MODIFIED_BASHRC=1  # assumes bashrc already has line to source the file
if [[ -z $GREPPED ]]; then
	unset MODIFIED_BASHRC # guarantees it is not set
	ECHO_COLOR $YELLOW NO
	ECHO_COLOR $YELLOW "---ACTION REQUIRED---"
	echo "Your .bashrc needs modification to load the installed completion engine automatically."
	echo "You can update your .bashrc by appending the following line to it:"
	echo -e "\t$BASHRC_LINE"
	ECHO_COLOR $BOLD "Would you like me to append the line to your .bashrc for you? [n] " 0
	read -n1
	echo ""
	if [[ "$REPLY" == "y" || "$REPLY" == 'Y' ]]; then
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

if [[ $? == 0 ]]; then
	ECHO_COLOR $YELLOWBOLD "\n---POST INSTALLATION ACTIONS---"
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

