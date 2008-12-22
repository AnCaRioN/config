#!/bin/bash


# SCRIPT d'install v1.0 pour archlinux i686

# TO DO
# Integrer fichier .Xdefaults(rxvt-unicode) et vimrc. Faire partie copie fichier cfg hal pr montage auto


#### #     #      #     #   # #####     #     ####   # ##### #   #
#  #  #   #      # #    ##  # #        # #    #  #   # #   # ##  #
####   # #      #####   # # # #       #####   ####   # #   # # # #
#  #    #      #     #  #  ## #      #     #  #   #  # #   # #  ##
####    #     #       # #   # ##### #       # #    # # ##### #   #


# Nom d'utilisateur
export user_install=david

# On crée tout d'abord l'utilisateur david

adduser $user_install


# Ajout du depot archlinuxfr dans pacman

echo '[archlinuxfr]' >> /etc/pacman.conf
echo 'Server = http://repo.archlinux.fr/i686' >> /etc/pacman.conf


# On rm /usr/lib/klibc/include/asm car il fait parfois chier avec la maj de klibc(2008.06)

rm /usr/lib/klibc/include/asm


# On met à jour la bete
# MAJ de paman d'abord
pacman -Syu << TAG_UPDATE_PACMAN
Y
TAG_UPDATE_PACMAN
# Puis du systeme installe par la suite
pacman -Syu << TAG_UPDATE
Y
TAG_UPDATE


# On commence à télécharger tout ce qu'il nous faut

pacman -S xorg hwd slim archlinux-themes-slim openbox obconf pcmanfm rxvt-unicode nvidia xcompmgr nitrogen xset numlockx hal dbus udev fam gparted dosfstools ntfsprogs reiserfsprogs ntfs-3g alsa-lib alsa-utils alsa-oss yaourt ntp firefox firefox-i18n flashplugin thunderbird thunderbird-i18n liferea gftp vim gvim emesene amule eog brasero comix evince vlc mplayer mplayer-plugin mplayer-skins codecs libdvdcss transcode libtheora jasper flac libdvdread xvidcore musepack-tools audacious-player audacious-plugins openoffice-base openoffice-fr unzip p7zip wine nmap virtualbox apache mysql php mcrypt vsftpd openssh gcolor2 scrot gcstar gimp openjdk6 conky clamav hddtemp pmount homebank git << TAG_INSTALL
Y
Y
TAG_INSTALL


# On syncronize l'horloge

ntpdate 0.pool.ntp.org


# On configure le son avec alsa

alsaconf


# On ajoute l'user à audio et vboxusers

gpasswd -a $user_install audio
gpasswd -a $user_install vboxusers
gpasswd -a $user_install optical
gpasswd -a $user_install storage


# Francisation de la distribution

echo 'export LESSCHARSET="utf-8"' >> /etc/profile
echo 'export G_FILENAME_ENCODING="@locale,UTF-8,ISO-8859-15"' >> /etc/profile
echo 'export LC_ALL="fr_FR.UTF-8"' >> /etc/profile

source /etc/profile

if(test -f /root/.bashrc)
then
  {
    source /root/.bashrc
  }
else
  {
    touch /root/.bashrc
    source /home/$user_install/.bashrc 
  }
fi


# Configuration du graphique

hwd -u << HWD_UPDATE
y
y
HWD_UPDATE

hwd -xa << HWD_CFG
y
HWD_CFG

nvidia-xconfig


# Pour le montage automatique des périfs
# Il faut avoir d'abord installé dbus hal et udev
# on va faire un dossier et on fera a coup de cp et autre


# Configuration de .xinitrc
cp .xinitrc /home/$user_install/.xinitrc
chown david:users /home/$user_install/.xinitrc


# Configuration de pcmanfm avec le theme d'icone gnome-brave

mkdir /home/$user_install/.icons
cp brave.tar.bz2 /home/$user_install/.icons/brave.tar.bz2
bunzip2 /home/$user_install/.icons/brave.tar.bz2
tar xf /home/$user_install/.icons/brave.tar
rm /home/$user_install/.icons/brave.tar

if(test -f '/home/$user_install/.gtkrc-2.0')
then
  {
    echo 'gtk-icon-theme-name="brave"' > .gtkrc-2.0
  }
else
  {
    touch /home/$user_install/.gtkrc-2.0
    echo 'gtk-icon-theme-name="brave"' > .gtkrc-2.0
    chown $user_install.users .gtkrc-2.0
  }
fi



# Contenu du fichier rc.conf à modifier
# MODULES=(skge slhc snd-mixer-oss snd-pcm-oss snd-hwdep snd-page-alloc snd-pcm snd-timer snd snd-hda-intel soundcore fuse vboxdrv)
# DAEMONS=(syslog-ng @slim network netfs crond @alsa hal @sshd @httpd @mysqld @vsftpd @fam @clamav @ntpd @hddtemp)

# /etc/slim.conf theme : archlinux-darch-white
