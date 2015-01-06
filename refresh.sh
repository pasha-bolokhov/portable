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
cp -a ./config/ssh/config ~/.ssh/

# Copy the Authorized Keys
cp -a ./config/ssh/authorized_keys ~/.ssh/

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
if ! grep -q '^### MARKER-BEGIN-PORTABLE' ~/.bashrc || ! grep -q '^### MARKER-END-PORTABLE' ~/.bashrc; then
    echo "Update ~/.bashrc with start-up/bashrc-user if needed manually"
else
    ed -s ~/.bashrc <<-EOF
	/^### MARKER-BEGIN-PORTABLE/,/^### MARKER-END-PORTABLE/ d
	.-1 r start-up/bashrc-user
	w
	Q
	EOF
fi

# Configuration file for GNU screen
cp -a ./start-up/screenrc ~/.screenrc

# Configuration file for tmux
cp -a ./start-up/tmux.conf ~/.tmux.conf

