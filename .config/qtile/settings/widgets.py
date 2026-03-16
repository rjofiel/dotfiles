# Qtile Widgets Configuration
# Modern style - TrainAtlas theme
# Todas las medidas en múltiplos de 2px

from libqtile import widget
from .theme import colors


def base(fg="text", bg="dark"):
    return {"foreground": colors[fg], "background": colors[bg]}


def separator(bg1="dark", bg2="dark"):
    return widget.Sep(
        foreground=colors["grey"][0],
        background=colors[bg1],
        linewidth=0,
        padding=8,
        size_percent=50,
    )


# GroupBox - solo números sin iconos
def workspaces():
    return [
        # Spacer para separar del layout (16px)
        widget.Spacer(length=16, background=colors["dark"]),
        widget.GroupBox(
            **base(fg="text"),
            font="Agave Nerd Font",
            fontsize=12,
            margin_y=4,
            margin_x=4,
            padding_y=2,
            padding_x=4,
            borderwidth=0,
            active=colors["active"],
            inactive=colors["inactive"],
            rounded=True,
            highlight_method="text",
            urgent_alert_method="text",
            this_current_screen_border=colors["focus"],
            this_screen_border=colors["grey"],
            other_current_screen_border=colors["dark"],
            other_screen_border=colors["dark"],
            disable_drag=True,
            visible_groups=["1", "2", "3", "4", "5", "6"],
        ),
        # Spacer para separar del window name (24px)
        widget.Spacer(length=24, background=colors["dark"]),
        # WindowName
        widget.WindowName(
            **base(fg="text"),
            fontsize=12,
            padding=8,
            format="{name}",
            empty_group_string="Desktop",
            max_chars=35,
        ),
        # Spacer que llena el espacio
        widget.Spacer(),
    ]


# Widgets simples sin iconos
primary_widgets = [
    # Updates - solo numero
    widget.CheckUpdates(
        background=colors["dark"],
        colour_have_updates=colors["text"],
        colour_no_updates=colors["grey"],
        no_update_string="0",
        display_format="{updates}",
        update_interval=3600,
        custom_command="checkupdates",
        fontsize=12,
        padding=6,
    ),
    separator("color3", "color3"),
    # WiFi status con GenmarshalText
    widget.GenPollText(
        **base(bg="color3"),
        func=lambda: (
            "ON"
            if "UP"
            in __import__("subprocess")
            .run(["ip", "link", "show", "wlan0"], capture_output=True, text=True)
            .stdout
            else "OFF"
        ),
        update_interval=30,
        fontsize=12,
        padding=6,
    ),
    separator("color3", "color2"),
    # Layout
    widget.CurrentLayout(
        **base(bg="color2"),
        fontsize=12,
        padding=6,
    ),
    *workspaces(),
    separator("dark", "color1"),
    # Clock
    widget.Clock(
        **base(bg="color1"),
        format="%H:%M",
        update_interval=60,
        fontsize=12,
        padding=6,
    ),
    # Spacer antes del tray (16px)
    widget.Spacer(length=16, background=colors["dark"]),
    # Systray - bg sólido
    widget.Systray(
        background=colors["dark"],
        icon_size=20,
        padding=6,
    ),
    widget.Spacer(length=10, background=colors["dark"]),
]


# Secondary bar for multi-monitor
secondary_widgets = [
    *workspaces(),
    separator("dark", "color1"),
    widget.CurrentLayout(**base(bg="color1"), fontsize=12, padding=4),
    separator("color1", "color2"),
    widget.Clock(
        **base(bg="color2"), format="%d %b  %H:%M", update_interval=60, fontsize=12
    ),
    widget.Spacer(length=10, background=colors["dark"]),
]


# Base widget configuration
widget_defaults = {
    "font": "Agave Nerd Font",
    "fontsize": 12,
    "padding": 2,
}
extension_defaults = widget_defaults.copy()
