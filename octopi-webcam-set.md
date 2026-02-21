# octopi-webcam-set.sh – ustawianie kamery OctoPi

Skrypt zmienia rozdzielczość i FPS kamery w OctoPi (mjpg-streamer). Wymaga uruchomienia **na Raspberry Pi** (sudo).

## Użycie

```bash
./octopi-webcam-set.sh <rozdzielczość> <fps>
```

- **rozdzielczość** – w formacie `szerokośćxwysokość`, np. `1024x768`, `1920x1440`
- **fps** – liczba klatek na sekundę, np. `10`, `20`, `30`

## Przykłady

```bash
./octopi-webcam-set.sh 1024x768 20
./octopi-webcam-set.sh 1920x1440 15
./octopi-webcam-set.sh 640x480 30
```

## Kopiowanie na RPi

```bash
scp octopi-webcam-set.sh mrnz@192.168.0.19:~/
ssh mrnz@192.168.0.19 'chmod +x ~/octopi-webcam-set.sh'
```

## Uwagi

- Kamera **Raspberry Pi Camera Module 2** ma natywny format **4:3** (np. 1920×1440, 1024×768).
- Po uruchomieniu skryptu odśwież podgląd kamery w OctoPrint.
