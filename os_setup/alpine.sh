#!/usr/bin/env sh
# alpine does not have bash

usage() {
	cat <<-EOF
		Usage: alpine [ -m | --mdns ] [ -h | --help ]
		[ -u | --user USER ]
	EOF
}

PARSED_ARGUMENTS=$(getopt -a -n alpine -o mh:u: --long mdns,help,user: -- "$@")

echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"
while :; do
	case "$1" in
	-m | --mdns)
		SETUP_MDNS=1
		shift
		;;
	-h | --help)
		usage
		shift
		exit
		;;
	-u | --user)
		CREATE_USER="$2"
		shift 2
		;;
	# -- means the end of the arguments; drop this, and break out of the while loop
	--)
		shift
		break
		;;
	# If invalid options were passed, then getopt should have reported an error,
	# which we checked as VALID_ARGUMENTS when getopt was called...
	*)
		echo "Unexpected option: $1 - this should not happen."
		usage
		;;
	esac
done

# Enable community package
sed -i 's/#\s?http/http/g' /etc/apk/repositories
apk update
# Install additional packages
apk add micro bash curl git tree
apk add shadow

# config doas, add user to wheel group for doas
apk add doas
echo "permit persist :wheel" >>/etc/doas.d/doas.conf

# Enable ssh
apk add openssh
rc-update add sshd
rc-service sshd start

# color prompt
ln -s /etc/profile.d/color_prompt.sh.disabled /etc/profile.d/color_prompt.sh

# Create user if command is passed
if [ -n "$CREATE_USER" ]; then
	setup-user "$CREATE_USER"
	adduser "$CREATE_USER" wheel
fi

if [ -n "$SETUP_MDNS" ]; then
	# setup mDNS
	apk add avahi
	rc-update add avahi-daemon
	rc-service avahi-daemon start
fi
