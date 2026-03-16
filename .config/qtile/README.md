# Qtile Configuration

My personal Qtile configuration (tiling window manager for Linux).

## Structure

```
.qtile/
├── config.py           # Entry point - settings imports
├── config.json         # Active theme (kronii/dracula)
├── autostart.sh        # Scripts that run at startup
├── settings/
│   ├── keys.py         # Keybindings
│   ├── groups.py       # Workspaces (1-6)
│   ├── layouts.py      # Layout types
│   ├── widgets.py      # Bar widgets
│   ├── screens.py      # Monitor configuration
│   ├── mouse.py       # Mouse bindings
│   ├── path.py        # Absolute paths
│   └── theme.py       # Theme loader
└── themes/
    ├── kronii.json     # Kronii theme (default)
    └── dracula.json   # Dracula theme
```

## Requirements

- **Qtile** installed
- **Python 3.13+**
- **Rofi** (menu)
- **Alacritty** (terminal)
- **Firefox** (browser)
- **Nerd Fonts** (Iosevka, UbuntuMono)

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super + j/k/h/l` | Move between windows (down/up/left/right) |
| `Super + f` | Toggle fullscreen |
| `Super + Shift + f` | Toggle floating |
| `Super + Tab` | Next layout |
| `Super + Shift + Tab` | Previous layout |
| `Super + q` | Close window |
| `Super + m` | Open Rofi (menu) |
| `Super + Return` | Open terminal (Alacritty) |
| `Super + b` | Open Firefox |
| `Super + s` | Screenshot (with maim) |
| `Super + Shift + e` | Lock screen (betterlockscreen) |
| `Super + r` | Redshift night mode |
| `Super + Shift + r` | Turn off Redshift |
| `Super + [1-6]` | Go to workspace N |
| `Super + Shift + [1-6]` | Move window to workspace N |
| `Ctrl + Super + r` | Restart Qtile |
| `Ctrl + Super + q` | Exit Qtile |

### Hardware
| Shortcut | Action |
|----------|--------|
| `Vol Up/Down` | Volume up/down |
| `Mute` | Mute |
| `Brightness Up/Down` | Screen brightness |

## Workspaces

6 workspaces available, navigable with `Super + [1-6]`.

## Layouts

1. **Spiral** - Spiral (default)
2. **Bsp** - Binary Space Partitioning
3. **MonadTall** - One large window on the left, stacked on the right
4. **RatioTile** - Tile with ratios
5. **Tile** - Classic tile
6. **Max** - Fullscreen (without tiling)

## Themes

Edit `config.json` to change theme:
```json
{"theme": "trainatlas"}
```
- **TrainAtlas**: Based on TrainAtlas palette (Forest Green, Aged Gold, Violet)
```json
{"theme": "kronii"}
```
- **Kronii**: Another theme
```json
{"theme": "dracula"}
```
- **Dracula**: Classic purple theme

## Memory and Performance

This config is optimized for low consumption:

- **CheckUpdates**: Updates every 1 hour (3600s)
- **Clock**: Updates every 60 seconds
- **Net**: Updates every 10 seconds

This reduces CPU vs defaults that update every second.

## Troubleshooting

### Qtile doesn't start
```bash
# Verify syntax
python3 -m py_compile ~/.config/qtile/config.py

# Verify imports
cd ~/.config/qtile && python3 -c "from settings.keys import *"
```

### Widget problems
- Check that Network interface in `widgets.py` (`wlp2s0`) is correct
- Verify that `checkupdates` is installed (package `pacman-contrib`)

### Multi-monitor
The script automatically detects monitors via xrandr.

## Inspiration

Based on the configuration of [Antonio Sarosi](https://github.com/antoniosarosi/dotfiles).
