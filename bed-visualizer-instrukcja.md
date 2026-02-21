# Bed Visualizer (1.1.2) – gdzie wkleić kod

Wizualizacja działa tak: **plugin musi „widzieć” odpowiedź drukarki z siatką poziomowania**. Żeby to zadziałało, w G-code **musi być linia `@BEDLEVELVISUALIZER`** tuż przed komendą, która każe drukarce **wypisać** siatkę (mesh).

## Gdzie wkleić kod

1. W OctoPrint: **Settings (Ustawienia) → Bed Visualizer**.
2. W sekcji **„Run Command”** / **„G-code Command”** (lub podobnej) wklej **cały blok G-code** – ten, który pasuje do Twojego firmware (Marlin / Prusa / Klipper).
3. Uruchom go przyciskiem **Run** / **Execute** w tej samej zakładce.

Alternatywnie: w zakładce **Bed Visualizer** jest często przycisk do **wysłania komendy** – tam wklejasz ten sam G-code i wysyłasz.

**Ważne:** `@BEDLEVELVISUALIZER` to znacznik dla pluginu (OctoPrint go ignoruje), a **drukarce** musisz wysłać właściwą komendę swojego firmware (np. `G29 T`, `G81`, `BED_MESH_OUTPUT`).

---

## Który kod wkleić (zależnie od firmware)

### Marlin (Bilinear, zwykłe G29)
```
M155 S30
@BEDLEVELVISUALIZER
G29 T
M155 S3
```

### Marlin (Unified Bed Leveling – UBL)
```
G29 P1
G29 P3
@BEDLEVELVISUALIZER
M420 S1 V
```

### Prusa (starsze MK3 i poniżej)
```
G80
@BEDLEVELVISUALIZER
G81
```
*Na i3 MK3S w ustawieniach pluginu włącz opcję „Y-axis flip”.*

### Prusa Mini (5.1.2+)
```
G28
M155 S30
G29
@BEDLEVELVISUALIZER
G29 T
M155 S3
```

### Klipper
```
@BEDLEVELVISUALIZER
BED_MESH_OUTPUT
```

---

## Jeśli wizualizacja dalej nie działa

- Sprawdź w ustawieniach Bed Visualizer **„G-code Response”** / regex – domyślne ustawienia są pod Marlin; dla Prusa/Klipper czasem trzeba dopasować.
- Upewnij się, że drukarka **wysyła** raport siatki (w Terminalu OctoPrint zobaczysz wtedy odpowiedź po wysłaniu powyższego G-code).
- Pełne przykłady (z nagrzewaniem, homingiem itd.): [gcode-examples.md w repozytorium pluginu](https://github.com/jneilliii/OctoPrint-BedLevelVisualizer/blob/master/wiki/gcode-examples.md).
