#!/usr/bin/bash
# install.sh
# installs bash completions to $HOME/.local

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

INSTALL_FILE=yagna
INSTALL_FILE_GOLEMSP=golemsp

if [[ ! -e $INSTALL_FILE ]]; then
	ECHO_COLOR $RED "the script file is not in the directory, so it cannot be installed!"
	exit
fi

TARGET_PATH=$HOME/.local/share/bash-completion/completions/$INSTALL_FILE
TARGET_PATH_GOLEMSP=$HOME/.local/share/bash-completion/completions/$INSTALL_FILE_GOLEMSP
INSTALL_CMD="install -m644 $INSTALL_FILE -D $TARGET_PATH"
INSTALL_CMD_GOLEMSP="ln -sf $TARGET_PATH $TARGET_PATH_GOLEMSP"
MD5_LOCAL=$(md5sum $INSTALL_FILE | cut -f1 -d" ")
MD5_TARGET=
if [[ -e $TARGET_PATH ]]; then
	MD5_TARGET=$(md5sum $TARGET_PATH | cut -f1 -d" ")
fi

VERSION_TAG=$(grep "# tag:" $INSTALL_FILE | sed -E 's/^[^:]*[:][[:space:]]*(.*)[[:space:]]*$/\1/' )

# cases
# the target path already exists
#	and it is not a version of gc__completion
#	it is a version of gc__completion
# post: INSTALLED_VERSION_TAG not NULL if the target path exists and it is a (previous) version of gc__completion
TARGET_EXISTS=0
INSTALLED_VERSION_TAG=
if [[ -e $TARGET_PATH ]]; then
	TARGET_EXISTS=1
	INSTALLED_VERSION_TAG=$(grep "# tag:" $TARGET_PATH | sed -E 's/^[^:]*[:][[:space:]]*(.*)[[:space:]]*$/\1/' 2>/dev/null)
fi

OVERWRITE_OK=0
if [[ $TARGET_EXISTS == 1 && ! $INSTALLED_VERSION_TAG ]]; then
	echo "The completion engine at $TARGET_PATH does not appear to be an existing version of gc__completion."
	ECHO_COLOR $BOLD "Okay to overwrite [n] " 0
	read -n1
	echo ""

	if [[ "$REPLY" == "y" || "$REPLY" == 'Y' ]]; then
		OVERWRITE_OK=1
	else
		ECHO_COLOR $BOLD aborting
		exit 1
	fi
fi

GOLEMSP_TARGET_EXISTS=0
GOLEMSP_INSTALLED_VERSION_TAG=
if [[ -L $TARGET_PATH_GOLEMSP ]]; then
	GOLEMSP_TARGET_EXISTS=1
	if [[ -e $TARGET_PATH_GOLEMSP ]]; then
		GOLEMSP_INSTALLED_VERSION_TAG=$(grep "# tag:" $TARGET_PATH | sed -E 's/^[^:]*[:][[:space:]]*(.*)[[:space:]]*$/\1/' 2>/dev/null)
	fi
fi


if [[ $GOLEMSP_TARGET_EXISTS == 1 && ! $GOLEMSP_INSTALLED_VERSION_TAG ]]; then
	echo "The completion engine at $TARGET_PATH_GOLEMSP does not appear to be an existing version of gc__completion."
	ECHO_COLOR $BOLD "Okay to overwrite [n] " 0
	read -n1
	echo ""
	if [[ "$REPLY" == "y" || "$REPLY" == 'Y' ]]; then
		OVERWITE_OK=1
	else
		ECHO_COLOR $BOLD aborting
		exit 1
	fi
fi

echo "installing target version '$VERSION_TAG'"
if [[ $OVERWRITE_OK == 1 ]]; then #simply install
	$INSTALL_CMD
	$INSTALL_CMD_GOLEMSP
else
	echo -n "checking if target version already installed..."
	ALREADY_INSTALLED=0
	GOLEMSP_ALREADY_INSTALLED=0
	if [[ -e $TARGET_PATH && ($MD5_LOCAL == $MD5_TARGET) ]]; then
		ECHO_COLOR $BOLD "YES" 0
		echo "...no update required"
		ALREADY_INSTALLED=1
	else
		ECHO_COLOR $BOLD "NO" 0
		echo " or update required"
	fi

	echo -n "checking if golemsp symlink has been set..."
	if [[ $GOLEMSP_TARGET_EXISTS == 1 ]]; then
		GOLEMSP_ALREADY_INSTALLED=1
		ECHO_COLOR $BOLD "YES"
	else
		ECHO_COLOR $BOLD "NO"
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

	if [[ $GOLEMSP_ALREADY_INSTALLED == 0 ]]; then
		echo -n "updating golemsp symlink..."
		$INSTALL_CMD_GOLEMSP
		if [[ $? == 0 ]]; then
			ECHO_COLOR $GREEN "OK"
		else
			ECHO_COLOR $RED "FAILED"
			exit
		fi
	fi

fi




if [[ $ALREADY_INSTALLED == 1 && $GOLEMSP_ALREADY_INSTALLED == 1 ]]; then
	ECHO_COLOR $BOLD "success. the install did not need to be updated."
else
	ECHO_COLOR $BOLD "installation successful"
	ECHO_COLOR $YELLOWBOLD "\n---POST INSTALLATION ACTIONS---"
	echo -n "to activate the completion engine "
	ECHO_COLOR $BOLD "start a new terminal session"
fi
