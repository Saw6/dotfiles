WM=$HOME/.config/monsterwm/monsterrun.sh

userresources=$HOME/.Xresources
if [ -f $userresources ]; then
  /usr/bin/xrdb -merge $userresources
fi

setxkbmap -layout ch -variant fr
xset +fp $HOME/.fonts
urxvtd &
sxhkd &
redshift -l 8.8383:13.2344 &
mpd &

if [ -z "$DESKTOP_SESSION" -a -x /usr/bin/ck-launch-session ]; then
  exec ssh-agent ck-launch-session dbus-launch --exit-with-session $WM
else
  exec ssh-agent dbus-launch --exec-with-session $WM
fi
