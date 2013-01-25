source ~/.git-completion.bash
source ~/.git-prompt.sh
export PS1='\w$(__git_ps1 "(%s)") > '

#I had to add back the .rvi dir, but bash still can't find rails.
export PATH=$PATH:/cat/bin:~/.rvm/bin:~/rubinius/bin


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

