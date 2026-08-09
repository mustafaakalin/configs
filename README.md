# my setup 
```bash
sudo pacman -S hyprshot thunar hyprlauncher lazygit fish neovim blueman wlsunset wlogout pavucontrol grim slurp flameshot hyprpicker swaync wallust network-manager-applet fd hyprtoolkit hyprcursor nm-connection-editor hyprsunset hyprlock hypridle nwg-look qt6-wayland qt5-wayland pipewire wireplumber xdg-desktop-portal-hyprland libreoffice-still podman-compose podman opencode rust wl-clipboard waybar kitty firefox-developer-edition hyprpaper firefox github-cli virt-manager waydroid obs-studio cups cups-pdf cups-filters ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds splix
```
```bash
yay -S layan-cursor-theme-git getnf hyprland-workspaces hyprcursor-dracula-kde-git xcursor-pro-hyprcursor nordzy-hyprcursors sweet-cursors-hyprcursor-git swayosd-git hyprswitch sysboard swaylock-effects-git hyprls-git ddccontrol ddcutil eedid-tool libayatana-appindicator-glib-git waydroid-image
```
nerd font
```bash
getnf 
```
virtual machine
```bash
# https://wiki.archlinux.org/title/Users_and_groups#Group_management
usermod -aG libvirt $USER  # https://wiki.archlinux.org/title/Virt-manager
sudo systemctl enable --now libvirtd.service
```
android
```bash
sudo waydroid init
waydroid session start # https://wiki.archlinux.org/title/Waydroid
waydroid show-full-ui
```
```bash
sudo systemctl enable --now cups.service
# http://localhost:631/
```
