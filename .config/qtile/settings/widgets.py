# import socket
# from libqtile.widget import widget
# from .theme import colors

# # Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)


# def base(fg='text', bg='dark'):
#     return {
#         'foreground': colors[fg],
#         'background': colors[bg]
#     }


# def separator(fg='text', bg='dark'):
#     return widget.Sep(**base(fg, bg), linewidth=0, padding=5)


# def icon(fg='text', bg='alpha', fontsize=16, text="?", font = 'Iosevka'):
#     return widget.TextBox(
#         **base(fg, bg),
#         fontsize=fontsize,
#         text=text,
#         font=font,
#         padding=0
#     )


# def rounded_left(fg="light", bg="alpha"):
#     return widget.TextBox(
#         **base(fg, bg),
#         text="",
#         padding=0,
#         fontsize=36
#     )


# def rounded_right(fg="light", bg="alpha"):
#     return widget.TextBox(
#         **base(fg, bg),
#         text="",
#         padding=0,
#         fontsize=37
#     )


# def sysmenu():
#     return [
#         widget.LaunchBar(
#             **base('active', 'color3'),
#             padding=5,
#             font='UbuntuMono Nerd Font',
#             fontsize=24,
#             progs=[("󰊠 ", "archlinux-logout", "System menu")],
#             text_only=True
#         )
#     ]


# def workspaces():
#     return [
#         widget.GroupBox(
#             **base(fg='light', bg='alpha'),
#             font='UbuntuMono Nerd Font Propo',
#             fontsize=14,
#             margin_y=2,
#             margin_x=5,
#             padding_y=10,
#             padding_x=5,
#             borderwidth=2,
#             visible_groups=["1", "2", "3", "4", "5", "6"],
#             active=colors['active'],
#             inactive=colors['inactive'],
#             center_aligned=True,
#             rounded=True,
#             highlight_method='block',
#             urgent_alert_method='block',
#             urgent_border=colors['urgent'],
#             this_current_screen_border=colors['focus'],
#             this_screen_border=colors['grey'],
#             other_current_screen_border=colors['dark'],
#             other_screen_border=colors['dark'],
#             disable_drag=True
#         ),
#     ]


# def layout_type():
#     return [
#         widget.CurrentLayoutIcon(**base(fg="color2", bg='color3'), scale=0.65),
#         widget.CurrentLayout(**base(fg='text', bg='color3'), padding=5),
#         icon(fg="text", bg="color3", text='|', fontsize=17),
#         separator(fg="color2", bg="color3"),
#         widget.WindowName(**base(bg='color3', fg='active'), fontsize=14, format="{name}",
#                           empty_group_string='Desktop', max_chars=34, markup=True, width=250, parse_text=parseLongName),
#     ]


# def systray():
#     return [
#         widget.Systray(background=colors['alpha'], icon_size=20, padding=4),
#     ]


# def battery():

#     if not socket.gethostname() in "x570aoruspro":
#         return [
#             icon(fg='text', bg='color3', text='', fontsize=28),
#             widget.Memory(
#                 **base(fg='text', bg='color3'),
#                 format='{MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}',
#                 fontsize=16,
#                 measure_mem='G'
#             ),
#             icon(fg='text', bg='color3', text=' | ', fontsize=17),
#             widget.Battery(
#                 **base(fg='text', bg='color3'),
#                 battery=1,
#                 fontsize=17,
#                 low_percentage=0.2,
#                 low_foreground=colors['active'],
#                 update_interval=1,
#                 format='{char} {percent:2.0%}',
#                 charge_char='ﮣ',
#                 discharge_char='',
#             ),
#             rounded_right('color3', 'alpha'),
#             separator(bg='alpha')
#         ]
#     else:
#        return []


# def date():
#     return [
#         icon(bg="color3", fontsize=20, text=" 󰃰 ", font='JetBrainsMonoNL Nerd Font '),
#         widget.Clock(**base(bg='color3'), format='%d %b | %A ')
#     ]


# def clock():
#     return [
#         icon(fg="text", bg="color3", fontsize=2, text='󰃰 ', font='JetBrainsMonoNL Nerd Font'),
#         widget.Clock(**base(fg='text', bg='color3'),
#                      fontsize=16,
#                      format='%I:%M %p'),
#     ]


# def icons_menu():
#     return [
#         icon(fg="text", bg="color3", text='罹', fontsize=26),
#         widget.CheckUpdates(
#             foreground=colors['text'],
#             background=colors['color3'],
#             colour_have_updates=colors['text'],
#             colour_no_updates=colors['text'],
#             no_update_string='0',
#             display_format=' {updates}',
#             update_interval=1800,
#             custom_command='checkupdates',
#             fontsize=16
#         ),
#         icon(fg="text", bg="color3",  text="", fontsize=28),
#         widget.Volume(
#             fontsize=16,
#             padding=10,
#             foreground=colors['text'],
#             background=colors['color3'],
#             volume_app='pavucontrol'
#             ),
#     ]


# def parseLongName(text):
#     for string in ["Chromium", "Firefox"]:  # Add any other apps that have long names here
#         if string in text:
#             text = string
#         else:
#             text = text
#     return text


# primary_widgets = [

#     *date(),

#     separator(bg='alpha'),

#     *battery(),

#     *layout_type(),

#     widget.Spacer(background=colors['alpha']),

#     *workspaces(),

#     widget.Spacer(background=colors['alpha']),

#     *systray(),
    
#     separator(bg='alpha'),

#     *icons_menu(),

#     *clock(),

#     *sysmenu()
# ]

# secondary_widgets = [
#     *workspaces()
# ]

# widget_defaults = {
#     #'font': 'UbuntuMono Nerd Font Bold',
#     #'font': 'VictorMono Nerd Font',
#     #'font': 'novamono for Powerline',
#     'font': 'Iosevka',
#     'fontsize': 14,
#     'padding': 1,
# }
# extension_defaults = widget_defaults.copy()

from libqtile import widget
from .theme import colors

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)

def base(fg='text', bg='dark'): 
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }


def separator():
    return widget.Sep(**base(), linewidth=0, padding=5)


def icon(fg='text', bg='dark', fontsize=16, text="?"):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=3
    )


def powerline(fg="light", bg="dark"):
    return widget.TextBox(
        **base(fg, bg),
        text="", # Icon: nf-oct-triangle_left
        fontsize=37,
        padding=-2
    )


def workspaces(): 
    return [
        separator(),
        widget.GroupBox(
            **base(fg='light'),
            font='UbuntuMono Nerd Font',
            fontsize=19,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            borderwidth=1,
            active=colors['active'],
            inactive=colors['inactive'],
            rounded=False,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['grey'],
            other_current_screen_border=colors['dark'],
            other_screen_border=colors['dark'],
            disable_drag=True
        ),
        separator(),
        widget.WindowName(**base(fg='focus'), fontsize=14, padding=5),
        separator(),
    ]


primary_widgets = [
    *workspaces(),

    separator(),

    powerline('color4', 'dark'),

    icon(bg="color4", text=' '), # Icon: nf-fa-download
    
    widget.CheckUpdates(
        background=colors['color4'],
        colour_have_updates=colors['text'],
        colour_no_updates=colors['text'],
        no_update_string='0',
        display_format='{updates}',
        update_interval=1800,
        custom_command='checkupdates',
    ),

    powerline('color3', 'color4'),

    icon(bg="color3", text=' '),  # Icon: nf-fa-feed
    
    widget.Net(**base(bg='color3'), interface='wlp2s0'),

    powerline('color2', 'color3'),

    # widget.CurrentLayoutIcon(**base(bg='color2'), scale=0.65),

    widget.CurrentLayout(**base(bg='color2'), padding=5),

    powerline('color1', 'color2'),

    icon(bg="color1", fontsize=17, text=' '), # Icon: nf-mdi-calendar_clock

    widget.Clock(**base(bg='color1'), format='%d/%m/%Y - %H:%M '),

    powerline('dark', 'color1'),

    widget.Systray(background=colors['dark'], padding=5),
]

secondary_widgets = [
    *workspaces(),

    separator(),

    powerline('color1', 'dark'),

    # widget.CurrentLayoutIcon(**base(bg='color1'), scale=0.65),

    widget.CurrentLayout(**base(bg='color1'), padding=5),

    powerline('color2', 'color1'),

    widget.Clock(**base(bg='color2'), format='%d/%m/%Y - %H:%M '),

    powerline('dark', 'color2'),
]

widget_defaults = {
    'font': 'UbuntuMono Nerd Font Bold',
    'fontsize': 14,
    'padding': 1,
}
extension_defaults = widget_defaults.copy()
