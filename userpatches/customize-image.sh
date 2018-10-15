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
	$APTINSTALL dosfstools ntfs-3g exfat-fuse exfat-utils hfsprogs hfsutils sshfs cifs-utils curlftpfs udevil
	mkdir -p /mnt/MPD/USB
}

Audio() {
	$APTINSTALL ssox jack libopus0 libfaad2 libmad0 libmms0 libid3tag0 libaudiofile1 mpg123 libpulse0 libav-tools bs2b-ladspa libbs2b0 libasound2-plugin-equal mpd mpc
}

Network() {
	$APTINSTALL avahi-daemon avahi-utils avahi-autoipd libnss-mdns ifplugd libupnp6 libxml2 yasm shairport-sync samba smbclient
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
