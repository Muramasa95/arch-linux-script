#!/bin/bash

echo -ne '

  ___  ______  _____  _   _   _     _____ _   _ _   ___   __
 / _ \ | ___ \/  __ \| | | | | |   |_   _| \ | | | | \ \ / /
/ /_\ \| |_/ /| /  \/| |_| | | |     | | |  \| | | | |\ V / 
|  _  ||    / | |    |  _  | | |     | | | . ` | | | |/   \ 
| | | || |\ \ | \__/\| | | | | |_____| |_| |\  | |_| / /^\ \
\_| |_/\_| \_| \____/\_| |_/ \_____/\___/\_| \_/\___/\/   \/
                                                            
                                                                                                                                             
'

echo "Welcome to Arch Linux, this script will install and create some configurations."
SCRIPTDIR=$PWD
cd $HOME

echo "***** Enabling multilib reposotiry and updating the system *****"
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf # enable multilib repositoryx
sudo pacman -Syyu --noconfirm
echo

echo "***** Installing vnstat to monitor and record network traffic *****"
cd $SCRIPTDIR
sudo mv vnstat /var/lib
cd $HOME
sudo pacman -S --noconfirm vnstat 
sudo systemctl enable vnstat.service
sudo systemctl start vnstat.service
vnstat --add -i wlp0s20f0u2
echo

echo "***** Installing and configuring firewall with ufw *****"
sudo pacman -S --noconfirm ufw
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 1714:1764/udp # kdeconnect
sudo ufw allow 1714:1764/tcp # kdeconnect
sudo ufw allow CIFS # samba
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo systemctl enable ufw
sudo systemctl start ufw
echo

echo "***** The script will install zsh and set it as the default shell *****"
sudo pacman -S --noconfirm zsh 
chsh -s /bin/zsh
echo

echo "***** Installing some fonts for AR, JP characters support *****"
sudo pacman -S --noconfirm noto-fonts-cjk noto-fonts ttf-dejavu ttf-opensans noto-fonts-emoji
echo

echo "***** Installing some important packages *****"
sudo pacman -S --noconfirm gthumb avahi neovim mpv discord ntfs-3g qbittorrent rar wget curl nemo-preview tailscale ffmpegthumbnailer samba telegram-desktop gst-plugins-good kitty dosfstools

echo "***** The script will now install yay *****"
sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd -- && rm -rf yay 
echo

echo "***** The script will install some AUR packages *****"
yay -S --noconfirm brave-bin windscribe-cli vscodium-bin jellyfin-mpv-shim rustdesk-bin ocs-url jdownloader2
echo

echo "***** The script will install nvm and nodejs *****"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node
echo

if (($XDG_CURRENT_DESKTOP == "KDE")); then
  echo "***** the desktop environment is KDE, installing kde based packages*****"
  echo "***** Installing dolphin and its extensions *****"
  sudo pacman -S --noconfirm dolphin dolphin-plugings
  echo "***** Installing missing kde settings packages *****"
  sudo pacman -S --noconfirm plasma-nm plasma-pa plasma-disks plasma-systemmonitor kscreen bluedevil kcalc kdialog
  echo "***** Installing important kde packages *****"
  sudo pacman -S --noconfirm strawberry kate spectacle qpwgraph ark  

elif (($XDG_CURRENT_DESKTOP == "gnome")); then
  echo "***** the desktop environment is Gnome, installing gnome based packages*****"

  echo "***** Installing nemo and its extensions *****"
  sudo pacman -S --noconfirm nemo nemo-terminal nemo-share nemo-python nemo-preview nemo-fileroller
  
  echo "***** Installing some important gnome packages *****"
  sudo pacman -S --noconfirm gthumb curl gnome-browser-connector gnome-tweaks

  echo "***** installing quodlibet ant its dependincies*****"
  sudo pacman -S --noconfirm quodlibet gst-plugins-good 

  echo "***** Changing the default directory application to nemo and default terminal for nemo*****"
  xdg-mime default nemo.desktop inode/directory
  gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty
  echo

  BEGINNING="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
  KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
    
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['$KEY_PATH/custom0/', '$KEY_PATH/custom1/', '$KEY_PATH/custom2/', '$KEY_PATH/custom3/', '$KEY_PATH/custom4/']"
  # Launch Terminal
  $BEGINNING/custom0/ name "Terminal"
  $BEGINNING/custom0/ command "terminator"
  $BEGINNING/custom0/ binding "<Super>Return"

  # Open up file browser
  $BEGINNING/custom1/ name "File Explorer"
  $BEGINNING/custom1/ command "nemo"
  $BEGINNING/custom1/ binding "<Super>E"

  # Launch Brave browser
  $BEGINNING/custom2/ name "Brave Browser"
  $BEGINNING/custom2/ command "/usr/bin/brave"
  $BEGINNING/custom2/ binding "<Super>B"

  # Launch vscodium
  $BEGINNING/custom3/ name "VSCodium"
  $BEGINNING/custom3/ command "codium"
  $BEGINNING/custom3/ binding "<Super>C"

  # Launch system monitor
  $BEGINNING/custom4/ name "System Monitor"
  $BEGINNING/custom4/ command "gnome-system-monitor"
  $BEGINNING/custom4/ binding "<Ctrl><Shift>Escape"
fi

while true; do
    read -p "Do you wish to install gaming packages? " yn
    case $yn in
          [Yy]* ) sudo pacman -S --noconfirm wine-staging winetricks wine-gecko wine-mono
                  sudo pacman -S --noconfirm steam lutris retroarch gamemode
                  echo "***** Installing ge proton to Steam, Lutris and Bottles *****"
                  yay -S --noconfirm heroic-games-launcher-bin lutris mangohud lib32-mangohud
                  break;
          [Nn]*  break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo

echo "***** Installing oh-my-zsh from git *****"
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cd $HOME
echo

echo "***** The script will install NvChad *****"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
echo

echo "***** The script will copy the config files *****"
cd $SCRIPTDIR
mv .zshrc $HOME 
mv .zsh_history $HOME
mv mpv $HOME/.config/
mv MangoHud $HOME/.config/
mv jellyfin-mpv-shim $HOME/.config/
mv kitty $HOME/.config/
mv retroarch $HOME/.config/
mv bullet-train.zsh-theme $HOME/.oh-my-zsh/themes/
sudo mv smb.conf /etc/samba/
cd $HOME
echo

echo -ne '
______ _____ _   _ _____ _____ _   _  ___________ 
|  ___|_   _| \ | |_   _/  ___| | | ||  ___|  _  \
| |_    | | |  \| | | | \ `--.| |_| || |__ | | | |
|  _|   | | | . ` | | |  `--. \  _  ||  __|| | | |
| |    _| |_| |\  |_| |_/\__/ / | | || |___| |/ / 
\_|    \___/\_| \_/\___/\____/\_| |_/\____/|___/  
                                                                                         
'
echo "The script will quit now."
