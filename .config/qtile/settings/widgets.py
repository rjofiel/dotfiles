import socket
from libqtile import widget
from .theme import colors

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)


def base(fg='text', bg='dark'):
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }


def separator(fg='text', bg='dark'):
    return widget.Sep(**base(fg, bg), linewidth=0, padding=5)


def icon(fg='text', bg='alpha', fontsize=16, text="?"):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=0
    )


def rounded_left(fg="light", bg="alpha"):
    return widget.TextBox(
        **base(fg, bg),
        text="",
        padding=0,
        fontsize=36
    )


def rounded_right(fg="light", bg="alpha"):
    return widget.TextBox(
        **base(fg, bg),
        text="",
        padding=0,
        fontsize=37
    )


def sysmenu():
    return [
        rounded_left('color3', 'alpha'),
        widget.LaunchBar(
            **base('active', 'color3'),
            padding=5,
            font='UbuntuMono Nerd Font',
            fontsize=24,
            progs=[("拉 ", "archlinux-logout", "System menu")],
            text_only=True
        )
    ]


def workspaces():
    return [
        widget.GroupBox(
            **base(fg='light', bg='alpha'),
            font='droid sans mono for powerline',
            fontsize=13,
            margin_y=2,
            margin_x=4,
            padding_y=10,
            padding_x=2,
            borderwidth=6,
            visible_groups=["1", "2", "3", "4", "5", "6"],
            active=colors['active'],
            inactive=colors['inactive'],
            center_aligned=True,
            rounded=True,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['grey'],
            other_current_screen_border=colors['dark'],
            other_screen_border=colors['dark'],
            disable_drag=True
        ),
    ]


def layout_type():
    return [
        rounded_left('color3', 'alpha'),
        widget.CurrentLayoutIcon(**base(fg="color2", bg='color3'), scale=0.65),
        widget.CurrentLayout(**base(fg='text', bg='color3'), padding=5),
        icon(fg="text", bg="color3", text='|', fontsize=17),
        separator(fg="color2", bg="color3"),
        widget.WindowName(**base(bg='color3', fg='active'), fontsize=14, format="{name}",
                          empty_group_string='Desktop', max_chars=34, markup=True, width=250, parse_text=parseLongName),
        rounded_right('color3', 'alpha')
    ]


def systray():
    return [
        rounded_left('color3', 'alpha'),
        widget.Systray(background=colors['color3'], icon_size=20, padding=4),
        rounded_right('color3', 'alpha')
    ]


def battery():

    if not socket.gethostname() in "x570aoruspro":
        return [
            rounded_left('color3', 'alpha'),
            icon(fg='text', bg='color3', text='', fontsize=28),
            widget.Memory(
                **base(fg='text', bg='color3'),
                format='{MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}',
                fontsize=16,
                measure_mem='G'
            ),
            icon(fg='text', bg='color3', text=' | ', fontsize=17),
            widget.Battery(
                **base(fg='text', bg='color3'),
                battery=1,
                fontsize=17,
                low_percentage=0.2,
                low_foreground=colors['active'],
                update_interval=1,
                format='{char} {percent:2.0%}',
                charge_char='ﮣ',
                discharge_char='',
            ),
            rounded_right('color3', 'alpha'),
            separator(bg='alpha')
        ]
    else:
       return []


def date():
    return [
        rounded_left('color3', 'alpha'),
        icon(bg="color3", fontsize=26, text=''),
        widget.Clock(**base(bg='color3'), format=' %d %b | %A'),
        rounded_right('color3', 'alpha')
    ]


def clock():
    return [
        rounded_left('color3', 'alpha'),
        icon(fg="text", bg="color3", fontsize=24, text=' '),
        widget.Clock(**base(fg='text', bg='color3'),
                     fontsize=16,
                     format='%I:%M %p'),
        rounded_right('color3', 'alpha')
    ]


def icons_menu():
    return [
        rounded_left('color3', 'alpha'),
        icon(fg="text", bg="color3", text='罹', fontsize=26),
        widget.CheckUpdates(
            foreground=colors['text'],
            background=colors['color3'],
            colour_have_updates=colors['text'],
            colour_no_updates=colors['text'],
            no_update_string='0',
            display_format=' {updates}',
            update_interval=1800,
            custom_command='checkupdates',
            fontsize=16
        ),
        rounded_right('color3', 'alpha'),
        separator(bg='alpha'),
        rounded_left('color3', 'alpha'),
        icon(fg="text", bg="color3",  text="", fontsize=28),
        widget.Volume(
            fontsize=16,
            padding=10,
            foreground=colors['text'],
            background=colors['color3'],
            volume_app='pavucontrol'
            ),
        rounded_right('color3', 'alpha')
    ]


def parseLongName(text):
    for string in ["Chromium", "Firefox"]:  # Add any other apps that have long names here
        if string in text:
            text = string
        else:
            text = text
    return text


primary_widgets = [

    *date(),

    separator(bg='alpha'),

    *battery(),

    *layout_type(),

    widget.Spacer(background=colors['alpha']),

    *workspaces(),

    widget.Spacer(background=colors['alpha']),

    *systray(),

    separator(bg='alpha'),

    *icons_menu(),

    separator(bg='alpha'),

    *clock(),

    separator(bg='alpha'),

    *sysmenu()
]

secondary_widgets = [
    *workspaces()
]

widget_defaults = {
    # 'font': 'UbuntuMono Nerd Font Bold',
    # 'font': 'novamono for Powerline',
    'font': 'Iosevka',
    'fontsize': 14,
    'padding': 1,
}
extension_defaults = widget_defaults.copy()
