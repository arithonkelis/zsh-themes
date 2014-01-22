function precmd {
}

setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
        local CMD=${1[(wr)^(*=*|sudo|-*)]}
        echo -n "\ek$CMD\e\\"
    fi
}

function setprompt {

setopt prompt_subst

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA GREY WHITE; do
        eval PR_$color='%{$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

case $TERM in
   aterm)
      PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%y | ${COLUMNS}x${LINES}\a%}'
      ;;
   xterm)
      PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%y | ${COLUMNS}x${LINES}\a%}'
      ;;
   screen)
      PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%y | ${COLUMNS}x${LINES}\e\\%}'
      ;;
   *)
      PR_TITLEBAR=''
      ;;
esac
if [[ "$TERM" == "screen" ]]; then
   PR_STITLE=$'%{\ekzsh\e\\%}'
else
   PR_STITLE=''
fi


PR_COLOR="%(!.$PR_RED.$PR_GREEN)"


RPROMPT='$PR_YELLOW%(?..command returned %?) \
$PR_COLOR<$PR_WHITE%* %n$PR_COLOR@$PR_WHITE%m$PR_COLOR:$PR_WHITE%l'
PROMPT='$PR_STITLE${(e)PR_TITLEBAR}\
%~ $PR_COLOR>$PR_WHITE'
}
setprompt

