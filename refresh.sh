#!/usr/bin/env bash
#

#
# This script installs or refreshes the home setup
# Author: Pavel A. Bolokhov
# Run this only after changes have been made to this common configuration
#


#
# Copy the executable files
#
chmod a+x bin/*
if [ ! -d ~/bin ]; then
	mkdir $HOME/bin
fi &&
cp -a bin/* ~/bin/


#
# SSH files
#

# Copy the SSH configuration
install -m 600 -D --target-directory ~/.ssh ./config/ssh/config

# Copy the Authorized Keys
install -m 600 -D --target-directory ~/.ssh ./config/ssh/authorized_keys

# On Cygwin - change the group of the copied SSH files
UNAME=$(uname -s)
if [ ${UNAME/CYGWIN_*/CYGWIN} = "CYGWIN" ]; then
	chgrp Users ~/.ssh/config
	chgrp Users ~/.ssh/authorized_keys
	chmod 644 ~/.ssh/config
	chmod 644 ~/.ssh/authorized_keys
fi


#
# Start-up scripts
#

# Copy start-up files
cp -a ./start-up/bash_aliases ~/.bash_aliases
updated_profile="no"
for PROFILE in ~/.bash_profile ~/.bash_login ~/.profile ~/.bashrc; do
	if ! grep -q -s '^### MARKER-BEGIN-PORTABLE' ${PROFILE} || ! grep -q -s '^### MARKER-END-PORTABLE' $PROFILE; then
		continue
	fi
	ed -s $PROFILE <<-EOF
		/^### MARKER-BEGIN-PORTABLE/,/^### MARKER-END-PORTABLE/ d
		.-1 r start-up/bashrc-user
		w
		Q
		EOF
    	updated_profile="yes"
done
if [ $updated_profile != "yes" ]; then
	echo "Update ~/.profile or ~/.bashrc with start-up/bashrc-user if needed manually" 1>&2
fi

# Configuration file for GNU screen
cp -a ./start-up/screenrc ~/.screenrc

# Configuration file for tmux
cp -a ./start-up/tmux.conf ~/.tmux.conf

# Configuration for emacs
cp -a ./start-up/emacs ~/.emacs

