source ~/.git-completion.bash
source ~/.git-prompt.sh
export PS1='\w$(__git_ps1 "(%s)") > '

#I had to add back the .rvi dir, but bash still can't find rails.
export PATH=$PATH:/cat/bin:~/.rvm/bin:~/rubinius/bin

LS_COLORS='no=00:fi=00:di=01;35:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;↪01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=0↪1;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.ja↪r=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=0↪1;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;↪35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.↪mpc=01;35:*.ogg=01;35:*.wav=01;35:';
export LS_COLORS

alias ls='ls --color=auto'
alias la='ls -la --color=auto'

# Show indication that a certain SSH key is loaded
function __prompt_ssh_agent {
    if [ ! "z" == "z${SSH_KEY_FINGERPRINT}"  ]; then
       keys=`ssh-add -l  2> /dev/null | cut -d ' ' -f 2`
       for k in ${keys}; do
            [ "z$k" == "z${SSH_KEY_FINGERPRINT}" ] && echo -n "K "
       done
    fi
}

# Show user name
function __prompt_username {
    echo -n "$(whoami | cut -c1-3)"
}

# Show host name
function __prompt_hostname {
  echo -n "\[\033[1;$((31 + $(hostname | cksum | cut -c1-3) % 6))m\]\$(hostname | cut -c1-4)"
}

# Show an message if under an SSH session
function __prompt_ssh {
    if [ -n "$SSH_CLIENT" ]; then
        echo -n 'SSH '
    fi
}

# Show GIT status in the prompt
# (This feature is provided by the ubuntu debian git package)
export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWUNTRACKEDFILES="yes"

function __prompt_git_branch {
    __git_ps1 "(%s)"
}


# Support function to compactify a path
# copied: http://stackoverflow.com/questions/3497885/code-challenge-bash-prompt-path-shortener
function __dir_chomp {
    local p=${1/#$HOME/\~} b s
    # Remove [ and ] from strings
    # (also, regular expression matching on [ ] below creates infinite recursion.)
    p=${p//[/ }
    p=${p//]/ }
    # Remove multiple spaces, don't need them
    p=${p//  / }
    s=${#p}
    while [[ $p != ${p//\/} ]]&&(($s>$2))
    do
        p=${p#/}
        [[ $p =~ \.?. ]]
        b=$b/${BASH_REMATCH[0]}
        p=${p#*/}
        ((s=${#b}+${#p}))
    done
    echo ${b/\/~/\~}${b+/}$p
}

# Show a compact version of the current directory
function __prompt_pwd {
    echo -n $(__dir_chomp  "$(pwd)" 15)
}


# Prompt output function
function proml {
  # The colors that the prompt uses
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"

  # Set title in xterm*
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac
# And finally, set the prompt
PS1="${TITLEBAR}\
$LIGHT_GREEN\
\$(__prompt_ssh_agent)\
$RED\
\$(date +%H%M) \
$LIGHT_RED\$(__prompt_username)\
$BLUE@\
$(__prompt_hostname)\
$WHITE \
\$(__prompt_ssh)\
$GREEN\$(__prompt_pwd)\
$RED\$(__prompt_git_branch)\
$GREEN\$ \
$LIGHT_GRAY"
PS2='> '
PS4='+ '
}

# Execute the prompt function
proml

##### ALIASES ######
alias ff='firefox &'

alias wg='wicd-gtk &'
alias nmd='sudo service network-manager stop'
alias nmu='sudo service network-manager start'
alias wcu='sudo service wicd start'
alias wcd='sudo service wicd stop'

alias gc='git commit -m'
alias gh='git checkout'
alias ga='git add'
alias gs='git status'

alias star='ssh youngi@stargate.cat.pdx.edu'
alias rita='ssh youngi@rita.cat.pdx.edu'
alias king='ssh youngi@king.cs.pdx.edu'

export TERM=xterm-256color

