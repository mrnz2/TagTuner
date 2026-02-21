#!/bin/bash
# Ustawienie kamery OctoPi: 1024x768, 20 fps
# Uruchom na RPi: bash octopi-webcam-1080p.sh  (będziesz musiał wpisać hasło sudo)

set -e
CONFIG="/boot/firmware/octopi.txt"

echo "Edycja $CONFIG - rozdzielczość 1024x768, 20 fps..."
sudo sed -i 's|^#camera_usb_options="-r 640x480 -f 10"$|camera_usb_options="-r 1024x768 -f 20"|' "$CONFIG"
sudo sed -i 's|camera_usb_options="-r 1920x1080 -f 10"|camera_usb_options="-r 1024x768 -f 20"|' "$CONFIG"

if grep -q '^camera_usb_options="-r 1024x768 -f 20"' "$CONFIG"; then
  echo "OK - config zapisany."
else
  echo "Uwaga: sprawdź czy w $CONFIG jest linia camera_usb_options."
  echo "Jeśli nie, dodaj ręcznie: camera_usb_options=\"-r 1024x768 -f 20\""
fi

echo "Restart webcamd..."
sudo systemctl restart webcamd

echo "Gotowe. Odśwież podgląd kamery w OctoPrint."
