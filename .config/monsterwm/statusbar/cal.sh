#!/usr/bin/env sh

source $(dirname $0)/config.sh

POSITION="-x 1235 -y 20"
TAILLE="-w 129 -h 14 -l 20"

TODAY=$(expr `date +'%d'` + 0)
MONTH=`date +'%m'`
YEAR=`date +'%Y'`
 
(echo ""; \
echo '    ^fg(#9898AE)'`date +'%A, %H:%M'`; \
echo '   Day:'`date +'%j'`' - Week:'`date +'%U'`; \
echo; cal | sed -re "s/(^|[ ])($TODAY)($|[ ])/\1^fg(red)\2^fg()^bg()\3/" | sed 's/^/ /'; \
[ $MONTH -eq 12 ] && YEAR=`expr $YEAR + 1`; echo; cal ` expr \( $MONTH + 1 \) % 12` $YEAR | sed 's/^/ /'; \
sleep 10) | dzen2 $POLICE $COULEUR $POSITION $TAILLE -e 'onstart=uncollapse;button1=exit;button3=exit'
