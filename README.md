# Dotfiles – Arch Linux + Qtile

## System
- **OS**: Arch Linux (x86_64)
- **Kernel**: Linux 6.12.61-1-lts
- **CPU**: Intel® Core™ i7-10870H (16) @ 5.00 GHz
- **GPU**: NVIDIA RTX 3060 Mobile + Intel UHD Graphics
- **RAM**: 32 GB
- **Display**: 15" · 1920x1080 · 240Hz
- **Locale**: en_US.UTF-8

## Stack
- **WM**: Qtile (X11)
- **Shell**: Zsh
- **Terminal**: Alacritty
- **Font**: Agave Nerd Font
- **Cursor**: Breeze_Default

## Packages
- **Qtile**: Window manager written in Python.
- **Zsh**: Shell configured with aliases, autocompletion and history persistence.
- **Alacritty**: Terminal.
- **fastfetch**: Tool to display system information quickly.
- **wallust**: Color generator from wallpaper.
- **pywal/wal**: Alternative for color generation.
- **feh**: Image viewer and wallpaper manager.
- **rofi**: Application launcher.
- **dunst**: Notification daemon.
- **picom**: Window compositor.
- **cbatticon**: Battery icon in systray.
- **blueberry-tray**: Bluetooth manager in systray.
- **betterlockscreen**: Lock screen.

---

## Package Installation

### Automatic Script

```bash
# Simulate installation (see what would be installed)
.config/scripts/install-packages.sh --dry

# Install only Pacman packages
.config/scripts/install-packages.sh

# Install Pacman + AUR (paru)
.config/scripts/install-packages.sh --aur
```

### Included Packages

| Category | Packages |
|-----------|----------|
| **Shell/Utils** | zsh, zsh-completions, bat, fastfetch, fzf, jq |
| **WM/UI** | qtile, alacritty, rofi, picom, dunst, feh, autorandr |
| **Hardware** | cbatticon, blueberry, brightnessctl, betterlockscreen |
| **Fonts** | ttf-nerd-fonts-symbols, ttf-nerd-fonts-symbols-mono |
| **Dev** | git, curl, wget, neovim, python |
| **Extras** | redshift, playerctl, maim, scrot, xdotool |

### AUR Packages (optional)

```bash
.config/scripts/install-packages.sh --aur
```

Includes: antigravity-bin, anydesk-bin, brave-bin, dropbox, vscode, etc.

---

## Dotfiles Installation

```bash
# Clone and install
git clone --bare git@github.com:rjofiel/dotfiles.git $HOME/.dotfiles
cd $HOME
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

# Or use the script (with automatic backup)
./install-dotfiles.sh
./install-dotfiles.sh --force  # If backup already exists
```

---

## Repository Structure

```
.config/
├── alacritty/           # Terminal config
├── qtile/               # Window manager
│   ├── autostart.sh    # Startup scripts
│   ├── config.py       # Main config
│   ├── settings/       # Modular configuration
│   └── themes/         # Color themes
├── rofi/               # Launcher
├── dunst/              # Notifications
├── picom/              # Compositor
├── zsh/                # Shell
├── fastfetch/          # System info
├── scripts/            # Personal scripts
├── systemd/user/       # User services
├── .colors/           # Theming system
└── .ssh/              # SSH configuration
```
