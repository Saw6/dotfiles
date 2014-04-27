case $- in
  *i*) ;;
  *) return ;;
esac


HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000

shopt -s histappend
shopt -s checkwinsize


# MAN COLOR     # # # #
man()
{
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[0;35m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;34m") \
    man "$@"
}


if [ -x $HOME/.config/bash/aliases ]; then
  . $HOME/.config/bash/aliases
fi

if [ -x $HOME/.config/bash/fonctions ]; then
  . $HOME/.config/bash/fonctions
fi

if [ -x $HOME/.config/bash/prompt ]; then
  . $HOME/.config/bash/prompt
fi


case $TERM in
  rxvt*)
    trap 'echo -ne "\e]0;${PWD/$HOME/~} : $BASH_COMMAND\007"' DEBUG ;;
esac
