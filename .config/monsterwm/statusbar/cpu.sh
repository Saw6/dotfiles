source $(dirname $0)/config.sh

POSITION="-x 1060 -y 20"
WIDTH="250"
LINES="13"
JAUNE="#9898AE"

cputop=$(ps axo %cpu,cmd --width 37 | sort -nr | grep -v "CMD" | head -n 10)

(echo ""; \
echo "           ^fg($JAUNE) Top CPU Processus"; \
echo ""; \
echo "$cputop"; \
sleep 10) | dzen2 -h 14 $POLICE $COULEUR $POSITION -w $WIDTH -l $LINES -e 'onstart=uncollapse;button1=exit;button3=exit'
