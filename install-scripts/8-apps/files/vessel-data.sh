#!/bin/bash -e

SHIP_DATA=/home/user/.vessel/vessel.data

sed -e 's/=.*$//' $SHIP_DATA > /tmp/ship.keys
YAD_CMD='yad --title="Vessel Data" --form --scroll '
while read -r field
do
  key=$(echo "$field" | cut -d= -f1)
  value=$(echo "$field" | cut -d= -f2)
  YAD_CMD="$YAD_CMD --field=\"$key\" --align=right \"$value\""
done < <(cat $SHIP_DATA)
YAD_OUT=$(eval "$YAD_CMD")
if [ $? -ne 0 ]; then
  exit 1
fi
echo "$YAD_OUT" | sed -e 's#|$##g' -e 's#|#\n#g' > /tmp/ship.values
paste -d= /tmp/ship.keys /tmp/ship.values > /tmp/ship.data.new
rm -f /tmp/ship.keys /tmp/ship.values
mv -f /tmp/ship.data.new $SHIP_DATA
