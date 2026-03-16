# =============================================================================
# TMUX CHEAT SHEET
# =============================================================================

## PREFIX
Ctrl+b           # Default prefix (or set TMUX_PREFIX in tmux.conf)

## SESSIONS
tmux new -s <name>           # New session
tmux ls                       # List sessions
tmux attach -t <name>         # Attach to session
tmux detach                   # Detach (prefix + d)
tmux kill-session -t <name>  # Kill session

## WINDOWS (tabs)
prefix + c          # New window
prefix + 0-9        # Switch to window by number
prefix + p          # Previous window
prefix + n          # Next window
prefix + l          # Last window
prefix + ,          # Rename window
prefix + &          # Close window

## PANES (splits)
prefix + %          # Split vertically
prefix + "          # Split horizontally
prefix + arrow      # Navigate panes
prefix + z          # Zoom pane
prefix + x          # Close pane
prefix + {          # Swap with previous pane
prefix + }          # Swap with next pane
prefix + space      # Toggle layout
prefix + M-arrow    # Resize pane

## COPY MODE (vi-like)
prefix + [          # Enter copy mode
q                   # Exit copy mode
h/j/k/l             # Navigate (vi keys)
v                   # Start selection
y                   # Yank selection
/                   # Search forward
?                   # Search backward

## OTHER
prefix + ?          # Show all keybindings
prefix + t          # Show time
prefix + :          # Command prompt

# =============================================================================
# SUGGESTED CUSTOM CONFIG
# =============================================================================
# Uncomment in tmux.conf for better experience:

# # Use Alt+arrow to switch panes without prefix
# bind -n M-Left select-pane -L
# bind -n M-Right select-pane -R
# bind -n M-Up select-pane -U
# bind -n M-Down select-pane -D

# # Start tmux automatically in .zshrc:
# if [ -z "$TMUX" ]; then
#     tmux attach || tmux new
# fi
