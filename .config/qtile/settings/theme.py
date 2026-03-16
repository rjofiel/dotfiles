# Qtile Theme Configuration
# Loads theme from JSON files in themes/ directory

import json
from os import path

from .path import qtile_path


def load_theme():
    theme = "trainatlas"

    config = path.join(qtile_path, "config.json")
    if path.isfile(config):
        with open(config) as f:
            theme = json.load(f)["theme"]
    else:
        with open(config, "w") as f:
            f.write(f'{{"theme": "{theme}"}}\n')

    theme_file = path.join(qtile_path, "themes", f"{theme}.json")
    if not path.isfile(theme_file):
        raise Exception(f'"{theme_file}" does not exist')

    with open(path.join(theme_file)) as f:
        return json.load(f)


# Always load colors
colors = load_theme()
