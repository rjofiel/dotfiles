# =============================================================================
# Zsh Configuration
# =============================================================================

stty stop undef

# -----------------------------------------------------------------------------
# Powerlevel10k Instant Prompt
# -----------------------------------------------------------------------------
export ZSH=$HOME/.oh-my-zsh
typeset -g POWERLEVEL10K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Cargar archivos compartidos
for file in $HOME/.config/scripts/utils/*; do
    autoload -U "$file"
done
source $HOME/.config/shell/exports
source $HOME/.config/shell/aliases
source $HOME/.config/shell/functions

# -----------------------------------------------------------------------------
# Oh-My-Zsh + Plugins
# -----------------------------------------------------------------------------
source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh
source ~/.git-prompt.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Plugins del sistema
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_CUSTOM/plugins/zsh-autosuggestions
source $HOME/.oh-my-zsh/plugins/sudo/sudo.plugin.zsh
source $HOME/.oh-my-zsh/plugins/*/*.plugin.zsh
source $HOME/.oh-my-zsh/plugins/git/git.plugin.zsh
source $HOME/.oh-my-zsh/plugins/ssh-agent/ssh-agent.plugin.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

plugins=(
    git
    ssh-agent
    kube-ps1
    sudo
)

# -----------------------------------------------------------------------------
# Prompt
# -----------------------------------------------------------------------------
autoload -Uz promptinit
promptinit
prompt adam1
PROMPT='$(kube_ps1)'$PROMPT

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# -----------------------------------------------------------------------------
# Keybindings
# -----------------------------------------------------------------------------
bindkey -e

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# SSH Agent settings
zstyle :omz:plugins:ssh-agent ssh-add-args -k -t forever -c -a /run/user/1000/ssh-auth
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent identities rc_simplr_rsa rj_github_ed

# -----------------------------------------------------------------------------
# Powerlevel10k Theme
# -----------------------------------------------------------------------------
source $HOME/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Finalize instant prompt
(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize

# -----------------------------------------------------------------------------
# NVM
# -----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
