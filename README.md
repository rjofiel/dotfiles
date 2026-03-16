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

---

## Sistema de Theming Unificado

Este dotfiles incluye un sistema de theming automático que genera colores desde el wallpaper y los aplica a todas las apps configuradas.

### Estructura

```
.config/
├── .colors/                    # Sistema de theming
│   ├── scripts/
│   │   ├── generate.sh         # Genera colores desde wallpaper
│   │   ├── apply-alacritty.sh  # Aplica colores a Alacritty
│   │   ├── apply-rofi.sh       # Aplica colores a Rofi
│   │   ├── apply-dunst.sh      # Aplica colores a Dunst
│   │   ├── apply-qtile.sh      # Aplica colores a Qtile
│   │   └── lib/
│   │       ├── accessibility.sh    # Validación WCAG
│   │       ├── backup.sh           # Backup de archivos
│   │       ├── restore.sh          # Restaurar desde backup
│   │       └── validate_colors.sh  # Validar formato colors.json
│   ├── colors.json            # Colores generados (formato pywal)
│   ├── themes/                # Themes originales
│   └── templates/             # Plantillas
├── scripts/
│   ├── wallpaper-cycle.sh     # Cambiar wallpaper manualmente
│   └── feh-randomized.sh     # Wallpaper aleatorio
└── qtile/
    ├── autostart.sh           # Restaura theming al iniciar
    └── themes/wallust.json    # Theme dinámico de Qtile
```

### Uso

#### Cambio automático (cada 10 minutos)
```bash
# Iniciar el timer
systemctl --user enable --now feh-randomizing-wallpaper.timer
```

#### Cambio manual
```bash
# Siguiente wallpaper + theming
Super + w

# Wallpaper anterior + theming  
Super + Shift + w

# Random wallpaper + theming
Super + Alt + w
```

#### Regenerar theming manualmente
```bash
# Generar colores desde un wallpaper específico
~/.config/.colors/scripts/generate.sh ~/Pictures/Wallpapers/mi-wallpaper.png

# Aplicar solo a una app
~/.config/.colors/scripts/apply-alacritty.sh
~/.config/.colors/scripts/apply-rofi.sh
~/.config/.colors/scripts/apply-dunst.sh
~/.config/.colors/scripts/apply-qtile.sh
```

#### Integración con Qtile
```bash
# Recargar Qtile después de cambiar theme
Super + Ctrl + r
```

### Accesibilidad WCAG

El sistema incluye validación automática de contraste:
- **Ratio mínimo**: 4.5:1 (WCAG AA)
- **Ajuste automático**: Si el contraste es bajo, se ajusta el foreground
- **Fallback**: Si no se puede alcanzar el ratio, usa colores seguros (#1a1b26 / #a9b1d6)

### Configuración

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `MIN_RATIO` | Ratio mínimo de contraste | 4.5 |
| `FALLBACK_BG` | Color de fallback para background | #1a1b26 |
| `FALLBACK_FG` | Color de fallback para foreground | #a9b1d6 |

---

## Atajos de Teclado (Qtile)

### General
| Atajo | Acción |
|-------|--------|
| `Super + Enter` | Abrir terminal |
| `Super + Q` | Cerrar ventana |
| `Super + Tab` | Cambiar layout |
| `Super + Ctrl + R` | Reiniciar Qtile |
| `Super + Ctrl + Q` | Salir de Qtile |

### Ventanas
| Atajo | Acción |
|-------|--------|
| `Super + J/K` | Cambiar ventana (stack) |
| `Super + H/L` | Shrink/Grow ventana principal |
| `Super + F` | Toggle ventana flotante |
| `Super + 1-9` | Cambiar a grupo |
| `Super + Shift + 1-9` | Mover ventana a grupo |

### Aplicaciones
| Atajo | Acción |
|-------|--------|
| `Super + M` | Rofi (menú) |
| `Super + E` | Explorador de archivos |
| `Super + Shift + E` | Betterlockscreen |

### Wallpaper
| Atajo | Acción |
|-------|--------|
| `Super + W` | Siguiente wallpaper + theming |
| `Super + Shift + W` | Wallpaper anterior + theming |
| `Super + Alt + W` | Random wallpaper + theming |

---

## Instalación

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
