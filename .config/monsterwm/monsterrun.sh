#!/usr/bin/env sh

wm=monsterwm
ff="/tmp/$RANDOM.monsterwm.fifo"

tags=('■' '■' '■' '■' '■')
layouts=('' '' '' '' '') 

[[ -p $ff ]] || mkfifo -m 600 "$ff"

function statusbar
{
  win="$(xdotool getactivewindow getwindowname)"

  echo -n "$win "
}

while read -t "0.5" -r wmout || true; do
    if [[ $wmout =~ ^(([[:digit:]]+:)+[[:digit:]]+ ?)+$ ]]; then
        read -ra desktops <<< "$wmout"

        tmp=
        for desktop in "${desktops[@]}"; do
            IFS=':' read -r d w m c u <<< "$desktop"
            # Tags labels
            label=${tags[$d]}
            # Current desktop color and enclosing char (yes/no)
            ((c)) && fg="7" bg="2" lc="\u7 " rc=" \ur" && layout=${layouts[$m]} || fg="1" bg="0" lc=" " rc=" "
            # Has windows ?
            ((w == 1)) && ((! c)) &&
              fg="6" lc="\u0 " rc=" \ur"
            ((w == 2)) && ((! c)) &&
              fg="5" lc="\u0 " rc=" \ur"
            ((w == 3)) && ((! c)) &&
              fg="4" lc="\u0 " rc=" \ur"
            ((w >= 4)) && ((! c)) &&
              fg="3" lc="\u0 " rc=" \ur"
            # Urgent windows ?
            ((u)) && fg="3" bg="1" lc="\u3 " rc=" \ur"

            tmp+="\f$fg\b$bg$lc$label$rc\fr\br"
        done
        # Merge the clients indications and the tile mode
        tmp+=" \u0\f7\b0|\u0\b0\f1 $layout \u0\b0\f7|\u0\b0\f1 "
    fi
    echo "$tmp $(statusbar)"
done < "$ff" | bar &

# Informations - dzen2
if [ -x $HOME/.config/monsterwm/statusinfo.sh ]; then
  . $HOME/.config/monsterwm/statusinfo.sh &
fi

$wm > "$ff"

rm $ff
