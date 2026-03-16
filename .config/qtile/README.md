# Qtile Configuration

Mi configuración personal de Qtile (tiling window manager para Linux).

## Estructura

```
.qtile/
├── config.py           # Entry point - imports de settings
├── config.json         # Tema activo (kronii/dracula)
├── autostart.sh        # Scripts que corren al inicio
├── settings/
│   ├── keys.py         # Keybindings
│   ├── groups.py       # Workspaces (1-6)
│   ├── layouts.py      # Tipos de layout
│   ├── widgets.py     # Widgets de la barra
│   ├── screens.py      # Config de monitores
│   ├── mouse.py        # Mouse bindings
│   ├── path.py         # Paths absolutos
│   └── theme.py        # Loader de temas
└── themes/
    ├── kronii.json     # Tema Kronii (default)
    └── dracula.json   # Tema Dracula
```

## Requisitos

- **Qtile** instalado
- **Python 3.13+**
- **Rofi** (menú)
- **Alacritty** (terminal)
- **Firefox** (navegador)
- **Nerd Fonts** (Iosevka, UbuntuMono)

## Atajos de Teclado

| Atajo | Acción |
|-------|--------|
| `Super + j/k/h/l` | Mover entre ventanas (down/up/left/right) |
| `Super + f` | Toggle fullscreen |
| `Super + Shift + f` | Toggle floating |
| `Super + Tab` | Siguiente layout |
| `Super + Shift + Tab` | Layout anterior |
| `Super + q` | Cerrar ventana |
| `Super + m` | Abrir Rofi (menú) |
| `Super + Return` | Abrir terminal (Alacritty) |
| `Super + b` | Abrir Firefox |
| `Super + s` | Screenshot (con maim) |
| `Super + Shift + e` | Lock screen (betterlockscreen) |
| `Super + r` | Redshift modo noche |
| `Super + Shift + r` | Apagar Redshift |
| `Super + [1-6]` | Ir a workspace N |
| `Super + Shift + [1-6]` | Mover ventana a workspace N |
| `Ctrl + Super + r` | Restart Qtile |
| `Ctrl + Super + q` | Salir de Qtile |

### Hardware
| Atajo | Acción |
|-------|--------|
| `Vol Up/Down` | Subir/bajar volumen |
| `Mute` | Silenciar |
| `Brightness Up/Down` | Brillo de pantalla |

## Workspaces

6 workspaces disponibles, navegables con `Super + [1-6]`.

## Layouts

1. **Spiral** - Espiral (default)
2. **Bsp** - Binary Space Partitioning
3. **MonadTall** - Una ventana grande a la izq, stacked a la derecha
4. **RatioTile** - Tile con ratios
5. **Tile** - Tile clásico
6. **Max** - Fullscreen (sin tiling)

## Temas

Editar `config.json` para cambiar tema:
```json
{"theme": "trainatlas"}
```
- **TrainAtlas**: Basado en la paleta de TrainAtlas (Forest Green, Aged Gold, Violet)
```json
{"theme": "kronii"}
```
- **Kronii**: Tema otro
```json
{"theme": "dracula"}
```
- **Dracula**: Tema clásico violeta

## Memoria y Performance

Esta config está optimizada para bajo consumo:

- **CheckUpdates**: Actualiza cada 1 hora (3600s)
- **Clock**: Actualiza cada 60 segundos
- **Net**: Actualiza cada 10 segundos

Esto reduce CPU vs defaults que actualizan cada segundo.

## Troubleshooting

### No inicia Qtile
```bash
# Verificar syntax
python3 -m py_compile ~/.config/qtile/config.py

# Ver imports
cd ~/.config/qtile && python3 -c "from settings.keys import *"
```

### Problemas con widgets
- Revisar que Network interface en `widgets.py` (`wlp2s0`) sea la correcta
- Verificar que `checkupdates` esté instalado (paquete `pacman-contrib`)

### Multi-monitor
El script detecta monitores automáticamente via xrandr.

## Inspiración

Basado en la configuración de [Antonio Sarosi](https://github.com/antoniosarosi/dotfiles).
