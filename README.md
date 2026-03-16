# Dotfiles – Arch Linux + Qtile

## Sistemas
- **OS**: Arch Linux (x86_64)
- **Kernel**: Linux 6.12.61-1-lts
- **CPU**: Intel® Core™ i7-10870H (16) @ 5.00 GHz
- **GPU**: NVIDIA RTX 3060 Mobile + Intel UHD Graphics
- **RAM**: 32 GB
- **Pantalla**: 15" · 1920x1080 · 240Hz
- **Locale**: en_US.UTF-8

## Stack
- **WM**: Qtile (X11)
- **Shell**: Zsh
- **Terminal**: Alacritty
- **Fuente**: Agave Nerd Font
- **Cursor**: Breeze_Default

## Paquetes
- **Qtile**: Window manager escrito en Python.
- **Zsh**: Shell configurada con alias, autocompletado y persistencia de historial.
- **Alacritty**: Terminal.
- **fastfetch**: Herramienta para mostrar información del sistema de manera rápida.
- **wallust**: Generador de colores desde wallpaper.
- **pywal/wal**: Alternativa para generación de colores.
- **feh**: Visor de imágenes y gestor de wallpapers.
- **rofi**: Launcher de aplicaciones.
- **dunst**: Demonio de notificaciones.
- **picom**: Compositor de ventanas.
- **cbatticon**: Indicador de batería en systray.
- **blueberry-tray**: Gestor de Bluetooth en systray.
- **betterlockscreen**: Pantalla de bloqueo.

---

## Instalación de Paquetes

### Script automático

```bash
# Simular instalación (ver qué se instalaría)
.config/scripts/install-packages.sh --dry

# Instalar solo Pacman
.config/scripts/install-packages.sh

# Instalar Pacman + AUR (paru)
.config/scripts/install-packages.sh --aur
```

### Paquetes incluidos

| Categoría | Paquetes |
|-----------|----------|
| **Shell/Utils** | zsh, zsh-completions, bat, fastfetch, fzf, jq |
| **WM/UI** | qtile, alacritty, rofi, picom, dunst, feh, autorandr |
| **Hardware** | cbatticon, blueberry, brightnessctl, betterlockscreen |
| **Fonts** | ttf-nerd-fonts-symbols, ttf-nerd-fonts-symbols-mono |
| **Dev** | git, curl, wget, neovim, python |
| **Extras** | redshift, playerctl, maim, scrot, xdotool |

### Paquetes AUR (opcional)

```bash
.config/scripts/install-packages.sh --aur
```

Incluye: antigravity-bin, anydesk-bin, brave-bin, dropbox, vscode, etc.

---

## Instalación de Dotfiles

```bash
# Clonar e instalar
git clone --bare git@github.com:rjofiel/dotfiles.git $HOME/.dotfiles
cd $HOME
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

# O usar el script (con backup automático)
./install-dotfiles.sh
./install-dotfiles.sh --force  # Si ya hay backup
```

---

## Estructura del repositorio

```
.config/
├── alacritty/           # Terminal config
├── qtile/               # Window manager
│   ├── autostart.sh    # Scripts de inicio
│   ├── config.py       # Config principal
│   ├── settings/       # Configuración modular
│   └── themes/         # Temas de colores
├── rofi/               # Launcher
├── dunst/              # Notificaciones
├── picom/              # Compositor
├── zsh/                # Shell
├── fastfetch/          # System info
├── scripts/            # Scripts personales
├── systemd/user/       # Servicios de usuario
├── .colors/           # Sistema de theming
└── .ssh/              # Configuración SSH
```
