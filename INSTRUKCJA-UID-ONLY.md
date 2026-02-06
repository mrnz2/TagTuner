# TagTuner UID-Only - Instrukcja krok po kroku

Prosty czytnik tagów NFC z enkoderem obrotowym dla Home Assistant.

## Spis treści

- [Wymagania](#wymagania)
- [Krok 1: Połączenia sprzętowe](#krok-1-połączenia-sprzętowe)
- [Krok 2: Instalacja ESPHome](#krok-2-instalacja-esphome)
- [Krok 3: Konfiguracja pliku YAML](#krok-3-konfiguracja-pliku-yaml)
- [Krok 4: Konfiguracja WiFi](#krok-4-konfiguracja-wifi)
- [Krok 5: Kompilacja i wgranie](#krok-5-kompilacja-i-wgranie)
- [Krok 6: Dodanie do Home Assistant](#krok-6-dodanie-do-home-assistant)
- [Krok 7: Testowanie](#krok-7-testowanie)
- [Krok 8: Tworzenie automatyzacji](#krok-8-tworzenie-automatyzacji)
- [Rozwiązywanie problemów](#rozwiązywanie-problemów)

---

## Wymagania

### Sprzęt

| Element | Opis | s
|---------|------|
| ESP32-C3 SuperMini | Mikrokontroler (lub ESP32-WROOM-32E) |
| PN532 NFC | Czytnik NFC z interfejsem I2C |
| HW-040 | Enkoder obrotowy z przyciskiem (opcjonalnie) |
| Kable | Dupont lub Grove |

### Oprogramowanie

- [Home Assistant](https://www.home-assistant.io/) (zalecane 2024.1+)
- [ESPHome](https://esphome.io/) (addon lub standalone)

### Pliki konfiguracyjne

| Plik | Płytka |
|------|--------|
| `uid-only.yaml` | ESP32-C3 SuperMini |
| `uid-only-esp32.yaml` | ESP32-WROOM-32E |

---

## Krok 1: Połączenia sprzętowe

### ESP32-C3 SuperMini

```
ESP32-C3 SuperMini          PN532 NFC
──────────────────          ─────────
3V3  ──────────────────────→ VCC
GND  ──────────────────────→ GND
GPIO4 ─────────────────────→ SDA
GPIO5 ─────────────────────→ SCL
```

```
ESP32-C3 SuperMini          HW-040 Encoder
──────────────────          ──────────────
3V3  ──────────────────────→ +
GND  ──────────────────────→ GND
GPIO6 ─────────────────────→ CLK
GPIO7 ─────────────────────→ DT
GPIO3 ─────────────────────→ SW
```

### ESP32-WROOM-32E

```
ESP32-WROOM-32E             PN532 NFC
───────────────             ─────────
3V3  ──────────────────────→ VCC
GND  ──────────────────────→ GND
GPIO21 ────────────────────→ SDA
GPIO22 ────────────────────→ SCL
```

```
ESP32-WROOM-32E             HW-040 Encoder
───────────────             ──────────────
3V3  ──────────────────────→ +
GND  ──────────────────────→ GND
GPIO25 ────────────────────→ CLK
GPIO26 ────────────────────→ DT
GPIO27 ────────────────────→ SW
```

### Konfiguracja PN532 - DIP Switches

Ustaw przełączniki na tryb **I2C**:

```
┌─────────────────────────┐
│  PN532 DIP Switches     │
│  ───────────────────    │
│   SW1   SW2             │
│  ┌───┐ ┌───┐            │
│  │ 1 │ │ 0 │  ← I2C     │
│  └───┘ └───┘            │
│                         │
│  1 = ON (góra)          │
│  0 = OFF (dół)          │
└─────────────────────────┘
```

---

## Krok 2: Instalacja ESPHome

### Opcja A: ESPHome jako addon Home Assistant (zalecane)

1. W Home Assistant idź do: `Settings → Add-ons`
2. Kliknij `ADD-ON STORE`
3. Wyszukaj `ESPHome`
4. Kliknij `INSTALL`
5. Po instalacji kliknij `START`
6. Włącz `Show in sidebar`

### Opcja B: ESPHome standalone (na komputerze)

```bash
# Instalacja przez pip
pip install esphome

# Uruchomienie dashboard
esphome dashboard /ścieżka/do/konfiguracji
```

Otwórz w przeglądarce: `http://localhost:6052`

---

## Krok 3: Konfiguracja pliku YAML

### W ESPHome Dashboard:

1. Kliknij `+ NEW DEVICE`
2. Kliknij `SKIP` (pomiń wizard)
3. Nadaj nazwę: `tagtuner`
4. Wybierz typ ESP32
5. Kliknij `SKIP` ponownie
6. Na kafelku urządzenia kliknij `EDIT`
7. **Zastąp całą zawartość** treścią odpowiedniego pliku:
   - `uid-only.yaml` dla ESP32-C3 SuperMini
   - `uid-only-esp32.yaml` dla ESP32-WROOM-32E
8. Kliknij `SAVE`

### Przez CLI:

```bash
# Skopiuj plik do katalogu ESPHome
cp uid-only.yaml /config/esphome/tagtuner.yaml
```

---

## Krok 4: Konfiguracja WiFi

Edytuj plik YAML i znajdź sekcję `wifi:`. Dodaj dane swojej sieci:

### Opcja A: Bezpośrednio w pliku

```yaml
wifi:
  ssid: "NazwaTwojejSieci"
  password: "TwojeHasloWiFi"
  ap:
    # Fallback hotspot
```

### Opcja B: Używając secrets.yaml (zalecane)

Utwórz plik `secrets.yaml` w katalogu ESPHome:

```yaml
# secrets.yaml
wifi_ssid: "NazwaTwojejSieci"
wifi_password: "TwojeHasloWiFi"
```

W pliku konfiguracyjnym użyj:

```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  ap:
```

---

## Krok 5: Kompilacja i wgranie

### Przez ESPHome Dashboard:

1. Na kafelku urządzenia kliknij menu `⋮` → `Install`
2. Wybierz metodę wgrywania:
   - **Plug into this computer** - pierwsze wgranie przez USB
   - **Wirelessly** - kolejne aktualizacje przez WiFi (OTA)
3. Jeśli przez USB - wybierz port COM/USB
4. Poczekaj na kompilację (~2-5 minut)
5. Firmware zostanie automatycznie wgrany

### Przez CLI:

```bash
# Tylko kompilacja
esphome compile uid-only.yaml

# Kompilacja i wgranie przez USB
esphome upload uid-only.yaml

# Kompilacja, wgranie i monitoring logów
esphome run uid-only.yaml

# Wgranie przez WiFi (OTA) - po pierwszym wgraniu
esphome upload uid-only.yaml --device tagtuner.local
```

---

## Krok 6: Dodanie do Home Assistant

Po wgraniu firmware ESP32 połączy się z WiFi.

1. Home Assistant automatycznie wykryje nowe urządzenie ESPHome
2. Pojawi się powiadomienie lub:
   - Idź do: `Settings → Devices & Services`
   - Znajdź kartę `ESPHome` lub `Discovered`
3. Kliknij `CONFIGURE`
4. Kliknij `SUBMIT`
5. Urządzenie zostanie dodane

### Encje w Home Assistant:

Po dodaniu będziesz miał dostęp do:

| Encja | Typ | Opis |
|-------|-----|------|
| `sensor.tagtuner_status` | Text Sensor | Aktualny status |
| `binary_sensor.tagtuner_tag_present` | Binary Sensor | Czy tag jest na czytniku |
| `button.tagtuner_restart` | Button | Restart urządzenia |

---

## Krok 7: Testowanie

### Test NFC:

1. Przyłóż dowolny tag NFC do czytnika PN532
2. LED powinien mignąć
3. W Home Assistant idź do: `Settings → Tags`
4. Powinien pojawić się nowy tag z UID (np. `04-A2-B3-C4-D5-E6-F7`)

### Test przycisków i enkodera:

1. Idź do: `Developer Tools → Events`
2. W polu "Listen to events" wpisz: `esphome.tagtuner_button`
3. Kliknij `START LISTENING`
4. Testuj akcje:

| Akcja | Oczekiwany wynik |
|-------|------------------|
| 1× klik | `action: "single"` |
| 2× szybko | `action: "double"` |
| 3× szybko | `action: "triple"` |
| Przytrzymanie 1s | `action: "long"` |

5. Dla enkodera nasłuchuj: `esphome.tagtuner_volume`
   - Obrót w prawo: `action: "up"`
   - Obrót w lewo: `action: "down"`

### Sprawdzenie logów:

W ESPHome Dashboard kliknij `LOGS` na kafelku urządzenia, aby zobaczyć szczegółowe logi.

---

## Krok 8: Tworzenie automatyzacji

### Przykład 1: Tag uruchamia playlistę

```yaml
automation:
  - alias: "NFC Tag - Ulubiona playlista"
    description: "Przyłożenie tagu uruchamia muzykę"
    trigger:
      - platform: tag
        tag_id: "04-A2-B3-C4-D5-E6-F7"  # Zamień na swój UID
    action:
      - service: media_player.play_media
        target:
          entity_id: media_player.salon
        data:
          media_content_id: "https://stream.rmf.fm/rmffm"
          media_content_type: music
```

### Przykład 2: Double click = Play/Pause

```yaml
automation:
  - alias: "TagTuner - Double click Play/Pause"
    trigger:
      - platform: event
        event_type: esphome.tagtuner_button
        event_data:
          action: "double"
    action:
      - service: media_player.media_play_pause
        target:
          entity_id: media_player.salon
```

### Przykład 3: Long press = Mute

```yaml
automation:
  - alias: "TagTuner - Long press Mute"
    trigger:
      - platform: event
        event_type: esphome.tagtuner_button
        event_data:
          action: "long"
    action:
      - service: media_player.volume_mute
        target:
          entity_id: media_player.salon
        data:
          is_volume_muted: true
```

### Przykład 4: Enkoder steruje głośnością

```yaml
automation:
  - alias: "TagTuner - Volume Up"
    trigger:
      - platform: event
        event_type: esphome.tagtuner_volume
        event_data:
          action: "up"
    action:
      - service: media_player.volume_up
        target:
          entity_id: media_player.salon

  - alias: "TagTuner - Volume Down"
    trigger:
      - platform: event
        event_type: esphome.tagtuner_volume
        event_data:
          action: "down"
    action:
      - service: media_player.volume_down
        target:
          entity_id: media_player.salon
```

### Przykład 5: Różne tagi = różne akcje

```yaml
automation:
  - alias: "NFC - Tag Niebieski = Radio RMF"
    trigger:
      - platform: tag
        tag_id: "04-11-22-33-44-55-66"
    action:
      - service: media_player.play_media
        target:
          entity_id: media_player.kuchnia
        data:
          media_content_id: "https://stream.rmf.fm/rmffm"
          media_content_type: music

  - alias: "NFC - Tag Czerwony = Spotify playlist"
    trigger:
      - platform: tag
        tag_id: "04-AA-BB-CC-DD-EE-FF"
    action:
      - service: media_player.play_media
        target:
          entity_id: media_player.salon
        data:
          media_content_id: "spotify:playlist:37i9dQZF1DXcBWIGoYBM5M"
          media_content_type: playlist
```

---

## Rozwiązywanie problemów

### PN532 nie wykrywa tagów

1. **Sprawdź DIP switches** - muszą być ustawione na I2C (1-0)
2. **Sprawdź połączenia** - SDA i SCL mogą być zamienione
3. **Sprawdź zasilanie** - PN532 wymaga stabilnego 3.3V
4. **Włącz skanowanie I2C** w YAML:
   ```yaml
   i2c:
     scan: True  # Tymczasowo włącz
   ```
   Sprawdź logi - powinien znaleźć urządzenie na adresie `0x24`

### ESP32 nie łączy się z WiFi

1. Sprawdź czy SSID i hasło są poprawne
2. Upewnij się, że sieć to 2.4GHz (nie 5GHz)
3. ESP32 utworzy własny hotspot `tagtuner-XXXX` - połącz się z nim i skonfiguruj WiFi

### LED nie świeci

1. Sprawdź pin LED w konfiguracji
2. Niektóre płytki mają LED active-low - dodaj/usuń `inverted: true`
3. Sprawdź czy LED nie jest uszkodzony

### Enkoder nie działa

1. Sprawdź połączenia CLK, DT, SW
2. Upewnij się, że piny są poprawne dla Twojej płytki
3. Sprawdź czy enkoder ma zasilanie (+)

### Home Assistant nie wykrywa urządzenia

1. Sprawdź czy ESP32 jest w tej samej sieci co HA
2. Sprawdź czy addon ESPHome jest uruchomiony
3. Ręcznie dodaj urządzenie przez IP: `Settings → Integrations → ESPHome → Add`

---

## Zdarzenia (Events) - referencja

| Zdarzenie | Dane | Opis |
|-----------|------|------|
| `tag_scanned` | `tag_id` | Standardowe zdarzenie HA po skanowaniu tagu |
| `esphome.tagtuner_button` | `action: single/double/triple/long` | Kliknięcie przycisku |
| `esphome.tagtuner_volume` | `action: up/down` | Obrót enkodera |

---

## Licencja

Ten projekt jest oparty na [TagTuner](https://github.com/luka6000/TagTuner) autorstwa LukaGra.

Licencja: [Creative Commons BY-NC-SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/)
