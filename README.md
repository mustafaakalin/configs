# mustafaakalin super configs
```bash
sudo pacman -S hyprshot thunar hyprlauncher lazygit fish neovim blueman wlsunset wlogout pavucontrol grim slurp hyprpicker swaync wallust network-manager-applet fd hyprtoolkit hyprcursor nm-connection-editor hyprsunset hyprlock hypridle nwg-look qt6-wayland qt5-wayland pipewire wireplumber xdg-desktop-portal-hyprland libreoffice-still podman-compose podman opencode wl-clipboard waybar kitty  hyprpaper firefox github-cli virt-manager waydroid obs-studio cups cups-pdf cups-filters ghostscript gsfonts foomatic-db-engine foomatic-db foomatic-db-ppds splix print-manager system-config-printer vlc cloudflared git openai-codex gemini-cli wine winetricks dotnet-runtime dotnet-sdk wine-mono wine-gecko php composer npm pnpm bun insomnia gemini-cli openai-codex claude-code qalculate-gtk hblock zellij ollama
```
```bash
yay -S layan-cursor-theme-git getnf hyprland-workspaces hyprcursor-dracula-kde-git xcursor-pro-hyprcursor nordzy-hyprcursors sweet-cursors-hyprcursor-git swayosd-git hyprswitch sysboard swaylock-effects-git hyprls-git ddccontrol ddcutil eedid-tool libayatana-appindicator-glib-git waydroid-image hyprmod searxng-git hermes-agent claude-code caelestia-shell-git cursor-clip-git
```
rustup installation
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # https://rustup.rs/
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
sudo systemctl enable --now waydroid-container.service
waydroid session start # https://wiki.archlinux.org/title/Waydroid
waydroid show-full-ui
sudo mount --bind ~/Downloads ~/.local/share/waydroid/data/media/0/Download 
```
```bash
sudo systemctl enable --now cups.service
# http://localhost:631/
```
laravel
```bash
composer global require laravel/installer
```

