#!/usr/bin/env bash
#
# <bitbar.title>BatteryTest</bitbar.title>
# <bitbar.version>v1.1</bitbar.version>
# <bitbar.author>Florian mientjes</bitbar.author>
# <bitbar.author.github>florianmientjes</bitbar.author.github>
#
# Battery status plugin
# by Florian Mientjes
#

battstat=$(pmset -g batt)

percentage=$( echo "$battstat" |
  tail -1 |
  cut -f2 |
  awk -F"; " '{print $1}' |
  cut -d' ' -f1
)

display="${percentage//\%}%"

if [[ $battstat = *"AC Power"* ]]; then
  display='⚡️'
fi


echo $display
echo "---"


echo "$battstat" |
  tail -1 |
  cut -f2 |
  awk -F"; " '{print $2}' |
  cut -d' ' -f1

echo "$battstat" |
  tail -1 |
  cut -f2 |
  awk -F"; " '{print $3}' |
  cut -d' ' -f1

