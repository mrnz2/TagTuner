#!/bin/bash
# Ustawienie kamery OctoPi – rozdzielczość i fps z parametrów
# Użycie: ./octopi-webcam-set.sh <rozdzielczość> <fps>
#   np.  ./octopi-webcam-set.sh 1024x768 20
#   np.  ./octopi-webcam-set.sh 1920x1080 15

set -e
CONFIG="/boot/firmware/octopi.txt"

usage() {
  echo "Użycie: $0 <szerokość>x<wysokość> <fps>"
  echo "  np.   $0 1024x768 20"
  echo "  np.   $0 1920x1440 15"
  exit 1
}

[[ $# -lt 2 ]] && usage

RES="$1"
FPS="$2"

# prosta walidacja: rozdzielczość w formacie NxN, fps liczba
if ! [[ "$RES" =~ ^[0-9]+x[0-9]+$ ]]; then
  echo "Błąd: rozdzielczość ma być w formacie np. 1024x768"
  usage
fi
if ! [[ "$FPS" =~ ^[0-9]+$ ]]; then
  echo "Błąd: fps ma być liczbą (np. 10, 20, 30)"
  usage
fi

echo "Ustawiam: rozdzielczość $RES, fps $FPS"

# odkomentuj domyślną linię i ustaw nowe wartości LUB zamień istniejące camera_usb_options
sudo sed -i "s|^#camera_usb_options=\"-r 640x480 -f 10\"\$|camera_usb_options=\"-r $RES -f $FPS\"|" "$CONFIG"
sudo sed -i "s|^camera_usb_options=\"-r [0-9]*x[0-9]* -f [0-9]*\"|camera_usb_options=\"-r $RES -f $FPS\"|" "$CONFIG"

if grep -q "camera_usb_options=\"-r $RES -f $FPS\"" "$CONFIG"; then
  echo "OK – config zapisany."
else
  echo "Uwaga: sprawdź $CONFIG. Możesz dodać ręcznie: camera_usb_options=\"-r $RES -f $FPS\""
fi

echo "Restart webcamd..."
sudo systemctl restart webcamd

echo "Gotowe. Odśwież podgląd kamery w OctoPrint."
