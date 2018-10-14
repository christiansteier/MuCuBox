#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
#
# This is the image customization script

# NOTE: It is copied to /tmp directory inside the image
# and executed there inside chroot environment
# so don't reference any files that are not already installed

# NOTE: If you want to transfer files between chroot and host
# userpatches/overlay directory on host is bind-mounted to /tmp/overlay in chroot

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4
APTINSTALL="apt-get -y --no-install-suggests --no-install-recommends install"

Main() {
	case $RELEASE in
		jessie)
			# your code here
			;;
		xenial)
			# your code here
			;;
		stretch)
			PreliminaryWork
			Filesystem
			Additional
			Audio
			Network
			InstallRompr
			UninstallUnecessaryPackages
			Final
			;;
		bionic)
			# your code here
			;;
	esac
} # Main

PreliminaryWork() {
	chage -d 99999 root
}

Additional() {
	$APTINSTALL libjpeg62-turbo watchdog ffmpeg
}

Filesystem() {
	$APTINSTALL ntfs-3g dosfstools exfat-utils sshfs cifs-utils curlftpfs udevil dosfstools
	mkdir -p /mnt/MPD/USB
}

Audio() {
	$APTINSTALL sox jack libopus0 mpd mpc
}

Network() {
	$APTINSTALL avahi-daemon avahi-utils avahi-autoipd libnss-mdns ifplugd libupnp6 libxml2 yasm shairport-sync
}

InstallRompr() {
	mkdir -p /var/www
	cd /var/www
	curl -LO https://github.com/fatg3erman/RompR/releases/download/1.22/rompr-1.22.zip
	unzip *.zip
	rm *. zip
	cd rompr
	mkdir prefs albumart
	$APTINSTALL nginx php-curl php-sqlite3 php-gd php-json php-xml php-mbstring php-fpm imagemagick
	chown -R www-data:www-data /var/www/rompr
}

UninstallUnecessaryPackages() {
        apt-get purge -y man-db groff-base haveged
        apt-get autoremove -y
        rm -f /var/lib/apt/lists/*archive*
        apt-get clean
}

Final() {
	chage -d 0 root
	cp -ar /tmp/overlay/root/* /
	echo "MusicBox" > /etc/hostname
}

Main "$@"
