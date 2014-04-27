#!/bin/sh

# Chemin vers les icônes...
BOULE="$HOME/.config/monsterwm/icons/"

# dzen2 
COULEUR="-fg #dddddd -bg #151515"
TAILLE="-w 700 -h 18"
POSITION="-x 700 -y 0"
TEXTE_POSIT="-ta right"
POLICE="-fn -*-termsyn-medium-*-normal-*-11-*-*-*-*-*-*-*"

# gdbar 
BAR_STYLE="-w 50 -h 1 -nonl"
BAR_FG_COULEUR="-fg #d9d9d9"
BAR_BG_COULEUR="-bg #555555"

# Couleurs
ROUGE="#CD749C"
VERT="#9C75DD"
JAUNE="#9898AE"
BLEU="#5786BC"
MAGENTA="#625566"

# Icônes
MUSIQUE_PLAY="$BOULE/note.xbm"
MUSIQUE_PAUSE="$BOULE/pause.xbm"
VOLUME_ON="$BOULE/spkr_01.xbm"
VOLUME_MUTE="$BOULE/spkr_02.xbm"
CPU="$BOULE/cpu.xbm"
MEMOIRE="$BOULE/mem.xbm"
HEURE="$BOULE/clock.xbm"

SEP="^fg(#2a2a2a) | ^fg()"

# Fonctions 
icon()
{
  echo "^fg($1)^i($2)^fg()"
}

# Informations
memoire()
{
  echo -n "$(echo "$(free -m | awk '/buffers\/cache/ {print $3}') / $(free -m | awk '/Mem/ {print $2}') * 100" | bc -l | gdbar $BAR_STYLE $BAR_FG_COULEUR $BAR_BG_COULEUR)"
}

cpu()
{
	PRC=$(cat /proc/loadavg | awk '{print $1}')
	if [[ $PRC < 1.00 ]]; then
	echo -n "$(echo "$PRC * 100" | bc -l | gdbar $BAR_STYLE $BAR_FG_COULEUR $BAR_BG_COULEUR)"
  else
	echo -n "$(echo "$PRC * 100" | bc -l | gdbar -min 100 -max 200 $BAR_STYLE -fg $ROUGE $BAR_BG_COULEUR)"
  fi
}

musique()
{
  # Si pause ou lecture, l'icône change, sinon elle disparait...
  music="$(mpc current -f "%artist% - [%title%|%file%]")"
  
  if [ -z "$music" ]; then
    music=""
  else
    smusic="$(mpc | sed -rn '2s/\[([[:alpha:]]+)].*/\1/p')"

    [ "$smusic" == "paused" ] && smusic="$(icon $BLEU $MUSIQUE_PAUSE)" || smusic="$(icon $BLEU $MUSIQUE_PLAY)"
  fi
  
  echo -n "$smusic $music"
}


volume()
{
  volume=$(amixer get Master | egrep -o "[0-9]+%" | tr -d "%")

  if [ -z "$(amixer get Master | grep "\[on\]")" ]; then
	  echo -n "$(icon $ROUGE $VOLUME_MUTE) $(echo $volume | gdbar $BAR_STYLE $BAR_BG_COULEUR -fg "#555555" | awk '{print $2}')"
  else
	  echo -n "$(icon $ROUGE $VOLUME_ON) $(echo $volume | gdbar $BAR_STYLE $BAR_BG_COULEUR $BAR_FG_COULEUR | awk '{print $2}')"
  fi
}

heure()
{
  echo $(date +"%H:%M")
}

# Boucle de lancement...
while :; do
  echo -n "$(musique)$SEP"
  echo -n "$(volume)$SEP"
  echo -n "$(icon $JAUNE $CPU) $(cpu | awk '{print $2}')$SEP"
  echo -n "$(icon $MAGENTA $MEMOIRE) $(memoire | awk '{print $2}')$SEP"
  echo "$(icon $VERT $HEURE) $(heure) "
  sleep "0.5"
done | dzen2 $COULEUR $TEXTE_POSIT $TAILLE $POSITION $POLICE
