# 🌤️ Wetter App - Setup-Anleitung

Eine vollständige Schritt-für-Schritt-Anleitung zur Einrichtung und Verwendung der Wetter-App.

## 📋 Voraussetzungen

### System-Anforderungen
- **Xcode:** 15.0 oder höher
- **iOS Deployment Target:** 16.0 oder höher
- **Swift:** 6.0
- **macOS:** Sonoma (14.0) oder höher für Entwicklung

### Benötigte Frameworks
- SwiftUI
- SwiftData
- CoreLocation
- MapKit
- Foundation

## 🔧 Projekt-Setup

### 1. Info.plist Konfiguration

#### Core Location Berechtigung (ERFORDERLICH)

Füge folgende Einträge in deine `Info.plist` hinzu:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Wir benötigen deinen Standort, um dir das aktuelle Wetter anzuzeigen.</string>
```

**Oder im Property List Editor:**
- **Key:** `Privacy - Location When In Use Usage Description`
- **Type:** `String`
- **Value:** `Wir benötigen deinen Standort, um dir das aktuelle Wetter anzuzeigen.`

💡 **Tipp:** Du kannst auch eine ausführlichere Beschreibung verwenden:
```
"Die Wetter-App verwendet deinen Standort, um lokale Wettervorhersagen anzuzeigen und dir personalisierte Kleidungsempfehlungen zu geben."
```

### 2. SwiftData ModelContainer Setup

Der ModelContainer wird automatisch in der App initialisiert:

```swift
@main
struct WetterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedLocation.self)
    }
}
```

### 3. Projekt-Struktur

Stelle sicher, dass deine Dateistruktur wie folgt aussieht:

```
WetterApp/
├── App/
│   └── WetterApp.swift
├── Views/
│   ├── ContentView.swift
│   ├── LocationCard.swift
│   ├── AddLocationView.swift
│   └── ClothingRecommendationView.swift
├── Models/
│   ├── SavedLocation.swift
│   ├── WeatherData.swift
│   └── ClothingItem.swift
├── Services/
│   ├── WeatherService.swift
│   ├── LocationManager.swift
│   └── GeocodingService.swift
└── Resources/
    ├── Info.plist
    └── Assets.xcassets
```

## ✨ Haupt-Features

### 1. **🌐 Kostenlose Wetter-API (Open-Meteo)**
- ✅ **Keine API-Key erforderlich** - sofort einsatzbereit
- ✅ **Kostenlos** für nicht-kommerzielle Nutzung
- ✅ **7-Tage-Vorhersage** mit Hoch/Tief-Temperaturen
- ✅ **Stündliche Vorhersage** für den aktuellen Tag
- ✅ **Aktuelle Wetterdaten** in Echtzeit
- ✅ **Wettercode-Interpretation** mit 11 verschiedenen Zuständen
- ✅ **Sonnenauf- und Untergangszeiten**
- ✅ **Tag/Nacht-Modi** für Icons

**API-Endpoint:** `https://api.open-meteo.com/v1/forecast`

**Parameter:**
- `latitude` & `longitude` - Koordinaten
- `current` - Aktuelle Temperatur & Wettercode
- `hourly` - Stündliche Daten für 24h
- `daily` - Tägliche Vorhersage für 7 Tage
- `timezone=auto` - Automatische Zeitzone

### 2. **📍 Core Location Integration**
- ✅ **Automatische Standorterkennung** bei App-Start
- ✅ **Reverse Geocoding** mit MapKit für Standortnamen
- ✅ **Berechtigungshandling** mit Status-Tracking
- ✅ **Fallback zu Amman** wenn Location nicht verfügbar
- ✅ **Schnellzugriff-Button** in Toolbar (📍)
- ✅ **Fehlerbehandlung** mit hilfreichen Meldungen
- ✅ **Retry-Mechanismus** bei Location-Problemen

**Authorization States:**
- `notDetermined` → Zeigt Permission-Dialog
- `authorizedWhenInUse` → Location wird abgerufen
- `denied` → Zeigt Fehlermeldung
- `restricted` → Zeigt System-Einschränkung

### 3. **💾 SwiftData Persistenz**
- ✅ **Standorte werden permanent gespeichert**
- ✅ **Automatisches Laden** beim App-Start
- ✅ **Sortierung** nach Erstellungsdatum
- ✅ **Swipe-to-Delete** mit Bestätigungs-Alert
- ✅ **isCurrentLocation Flag** für aktuellen Standort
- ✅ **UUID-basierte IDs** für eindeutige Identifikation

**SavedLocation Model:**
```swift
@Model
final class SavedLocation {
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var isCurrentLocation: Bool
    var createdAt: Date
}
```

### 4. **🎨 iOS 26 Liquid Glass Design**
- ✅ **Glassmorphism-Effekte** mit `.glassEffect()`
- ✅ **Interaktive Animationen** mit Spring-Effekten
- ✅ **Wetter-basierte Farbanpassung** der Location-Cards
- ✅ **Haptic Feedback** für alle Interaktionen
- ✅ **Smooth Transitions** zwischen States
- ✅ **Dynamic Tinting** basierend auf Wetterbedingungen
- ✅ **Shadow-Effekte** für mehr Tiefe

**Glassmorphism-Modi:**
- `.regular` - Standard-Glas-Effekt
- `.tint(.blue.opacity(0.2))` - Farbige Tönung
- `.interactive()` - Reagiert auf Touch

### 5. **👕 Intelligente Kleidungsempfehlungen (NEU!)**
- ✅ **Temperatur-basierte Empfehlungen** - 7 Kategorien
- ✅ **Wetter-spezifische Anpassungen** (Regen, Schnee, Wind)
- ✅ **Visuelle Kleidungs-Icons** mit Emoji
- ✅ **Detaillierte Erklärungen** für jedes Item
- ✅ **Farbcodierte Temperatur-Badges**
- ✅ **Interaktive Detail-Sheets**
- ✅ **4 Kleidungsstück-Empfehlungen** gleichzeitig

**Temperatur-Kategorien:**
| Temp | Kategorie | Farbe | Beispiel-Kleidung |
|------|-----------|-------|-------------------|
| < 0°C | SEHR KALT | Blau | Winterjacke, Schal, Handschuhe |
| 0-8°C | KALT | Blau | Warme Jacke, Pullover |
| 9-15°C | KÜHL | Cyan | Übergangsjacke, Langarmshirt |
| 16-22°C | MILD | Grün | T-Shirt, leichte Jacke |
| 23-29°C | WARM | Orange | T-Shirt, Shorts, Sonnenbrille |
| 30-34°C | HEISS | Rot | Tank Top, Cap, Sonnencreme |
| 35°C+ | SEHR HEISS | Rot | Minimale Kleidung |

**Wetter-Modifier:**
- ☔ **Regen** → Regenjacke oder Regenschirm
- ❄️ **Schnee** → Winterstiefel, Handschuhe
- 💨 **Wind** → Windbreaker
- ☀️ **Sonnig** → Sonnenbrille, Sonnencreme

### 6. **🌍 Weltweite Städte-Datenbank**
- ✅ **100+ vordefinierte Städte** weltweit
- ✅ **Suchfunktion** mit Filter
- ✅ **Kategorien:** Deutschland, Europa, Naher Osten, Asien, Amerika, Ozeanien, Afrika
- ✅ **Schneller Zugriff** ohne externe API
- ✅ **Ländernamen** für bessere Identifikation

**Städte-Kategorien:**
- 🇩🇪 **Deutschland:** 10 Großstädte
- 🇪🇺 **Europa:** 20 Metropolen
- 🇦🇪 **Naher Osten:** 14 Städte
- 🇯🇵 **Asien:** 10 Städte
- 🇺🇸 **Amerika:** 11 Städte
- 🇦🇺 **Ozeanien:** 3 Städte
- 🇿🇦 **Afrika:** 6 Städte

### 7. **⚡ Performance-Features**
- ✅ **Asynchrone Datenladung** mit async/await
- ✅ **Lazy Loading** für Location-Cards
- ✅ **Auto-Refresh** alle 10 Minuten
- ✅ **Effizientes Caching** mit SwiftData
- ✅ **Retry-Mechanismus** bei API-Fehlern
- ✅ **Timeout-Handling** für Netzwerk-Requests
- ✅ **Debouncing** für Suchfunktion

### 8. **🌙 Tag/Nacht-Unterstützung**
- ✅ **Dynamische Icon-Auswahl** basierend auf Tageszeit
- ✅ **Sonnenauf-/Untergangszeiten** von API
- ✅ **Fallback-Logik** (18:00-06:00 = Nacht)
- ✅ **Unterschiedliche Icons** für Tag/Nacht

**Beispiele:**
- ☀️ **Tag:** sun.max.fill, cloud.sun.fill
- 🌙 **Nacht:** moon.stars.fill, cloud.moon.fill

## 🚀 Verwendung der App

### Erste Schritte

1. **App starten**
   - Tippe auf das Wetter-App-Icon
   - Die App startet automatisch

2. **Location-Berechtigung erteilen**
   - System-Dialog erscheint
   - Tippe auf "App während Verwendung erlauben"
   - Location wird automatisch erkannt

3. **Automatischer Standort**
   - App zeigt Wetter für deinen aktuellen Standort
   - Reverse Geocoding lädt Standortnamen
   - Wetterdaten werden von Open-Meteo API geladen

4. **Wetterdaten erkunden**
   - Aktuelle Temperatur (große Anzeige)
   - Stündliche Vorhersage (horizontaler Scroll)
   - 7-Tage-Vorhersage (scrollbare Liste)

### Standorte hinzufügen

#### Option 1: Suche verwenden
1. Tippe auf **Plus-Icon (➕)** in der "Meine Standorte" Sektion
2. Gib Stadtname in Suchfeld ein (z.B. "Berlin")
3. Liste wird automatisch gefiltert
4. Tippe auf gewünschte Stadt
5. Stadt wird gespeichert und erscheint in der Liste

#### Option 2: Beliebte Städte durchsuchen
1. Öffne "Standort hinzufügen" (➕)
2. Scrolle durch "Beliebte Städte" Liste
3. Wähle aus über 100 vordefinierten Städten
4. Tippe auf Stadt → automatisch gespeichert

**Verfügbare Städte:**
- 🇩🇪 Deutschland: Berlin, München, Hamburg, Köln, Frankfurt, etc.
- 🇪🇺 Europa: London, Paris, Rom, Madrid, Amsterdam, etc.
- 🇦🇪 Naher Osten: Dubai, Abu Dhabi, Amman, Beirut, etc.
- 🌍 Weltweit: New York, Tokyo, Sydney, etc.

### Zwischen Standorten wechseln

1. **Standort auswählen**
   - Scrolle zur "Meine Standorte" Sektion
   - Tippe auf eine Location-Card
   - Wetter wird für diesen Standort geladen

2. **Visual Feedback**
   - Card-Animation (Scale + Haptic)
   - Neue Wetterdaten laden
   - Temperatur & Icons aktualisieren

3. **Zurück zum aktuellen Standort**
   - Tippe auf Location-Icon (📍) oben links
   - GPS-Standort wird neu ermittelt
   - Aktuelle Wetterdaten laden

### Kleidungsempfehlungen verwenden (NEU! 👕)

1. **Empfehlungen öffnen**
   - Tippe auf T-Shirt-Icon (👕) oben rechts
   - Sheet öffnet sich mit voller Ansicht

2. **Temperatur-Badge ansehen**
   - Farbcodiertes Badge zeigt Kategorie
   - z.B. "MILD" (Grün) bei 18°C
   - z.B. "HEISS" (Rot) bei 32°C

3. **Kleidungs-Icons erkunden**
   - 4 empfohlene Kleidungsstücke
   - Emoji-Icons für visuelle Identifikation
   - Angepasst an Temperatur & Wetter

4. **Details ansehen**
   - Tippe auf ein Kleidungsstück
   - Detail-Sheet öffnet sich
   - Lese "Warum?"-Erklärung

**Beispiel-Empfehlungen:**
- **0°C (KALT):** 🧥 Warme Jacke, 👕 Pullover, 👖 Lange Hose
- **18°C (MILD):** 👕 T-Shirt, 🧥 Leichte Jacke (optional)
- **Regen + 12°C:** ☔ Regenjacke, 👢 Wasserdichte Schuhe
- **32°C (HEISS):** 👕 Tank Top, 🩳 Shorts, 🧢 Cap, 🧴 Sonnencreme

### Wetter aktualisieren

#### Automatische Aktualisierung
- Alle **10 Minuten** automatisch
- Läuft im Hintergrund
- Kein Benutzer-Eingriff nötig
- Timer stoppt wenn App geschlossen wird

#### Manuelle Aktualisierung
1. Tippe auf **Aktualisieren-Icon (⟳)** oben rechts
2. Wetterdaten werden neu geladen
3. Alle Standorte aktualisieren sich

### Standorte löschen

1. **Swipe-to-Delete**
   - Swipe Location-Card nach links
   - Roter "Löschen"-Button erscheint
   - Tippe auf "Löschen"

2. **Bestätigen**
   - Alert-Dialog erscheint
   - "Standort wirklich löschen?"
   - Zeigt Standortnamen an
   - Wähle "Löschen" oder "Abbrechen"

3. **Automatischer Fallback**
   - Falls gelöschter Standort aktiv war
   - App wechselt zu aktuellem GPS-Standort
   - Neue Wetterdaten werden geladen

⚠️ **Hinweis:** Aktueller GPS-Standort kann NICHT gelöscht werden (isCurrentLocation = true)

### Wetterdaten interpretieren

#### Aktuelles Wetter
- **Große Temperatur-Anzeige** - Aktuelle Temperatur in °C
- **Wetter-Icon** - Visualisierung (Sonne, Wolken, Regen)
- **Wetterbeschreibung** - Text (Sonnig, Bewölkt, Regen)
- **H: / T:** - Hoch/Tief-Temperatur für heute

#### Stündliche Vorhersage
- **"Jetzt"** - Aktuelle Stunde
- **Uhrzeit** - z.B. "14:00", "15:00"
- **Icon** - Wetter-Symbol
- **Temperatur** - Vorhergesagte Temperatur

#### 7-Tage-Vorhersage
- **Tag** - "Heute", "Mo", "Di", etc.
- **Icon** - Wetter-Symbol (immer Tag-Icons)
- **Temperatur-Balke** - Visuelle Darstellung der Temperaturspanne
- **Tief/Hoch** - Min/Max Temperatur des Tages

## 🛠 Technische Details

### Verwendete Frameworks

#### Apple Frameworks
- **SwiftUI** - Deklaratives UI Framework
- **SwiftData** - Moderne Datenpersistenz (iOS 17+)
- **CoreLocation** - GPS & Standorterkennung
- **MapKit** - Reverse Geocoding & Karten
- **Foundation** - URLSession für API-Calls

#### Swift Features
- **Swift 6.0** - Moderne Sprach-Features
- **async/await** - Asynchrone Programmierung
- **@Observable Macro** - State Management
- **@Model Macro** - SwiftData Models
- **@Query** - Reaktive Datenbank-Abfragen

### Architektur-Pattern

#### MVVM-ähnliche Struktur
```
┌─────────────────┐
│     Views       │  ContentView, LocationCard, AddLocationView
│  (SwiftUI)      │  ClothingRecommendationView
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  ViewModels     │  @Observable Classes
│  (@Observable)  │  LocationManager, WeatherService
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│     Models      │  @Model Classes (SwiftData)
│  (SwiftData)    │  SavedLocation, WeatherResponse
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Services      │  API Integration
│  (Networking)   │  Open-Meteo, Nominatim
└─────────────────┘
```

#### State Management
- **@Observable** - LocationManager, WeatherService (shared Singletons)
- **@State** - View-lokale States (isLoading, showingSheet)
- **@Query** - SwiftData-Queries (savedLocations)
- **@Environment** - ModelContext, Dismiss

### API-Integration

#### Open-Meteo Weather API

**Base URL:** `https://api.open-meteo.com/v1/forecast`

**Request-Beispiel:**
```swift
let url = "https://api.open-meteo.com/v1/forecast"
    + "?latitude=52.52&longitude=13.405"
    + "&current=temperature_2m,weathercode"
    + "&hourly=temperature_2m,weathercode"
    + "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset"
    + "&timezone=auto"
    + "&forecast_days=7"
```

**Response-Struktur:**
```json
{
  "current": {
    "temperature_2m": 18.5,
    "weathercode": 0,
    "time": "2026-01-16T14:00"
  },
  "hourly": {
    "time": ["2026-01-16T00:00", ...],
    "temperature_2m": [12.3, 13.1, ...],
    "weathercode": [0, 1, ...]
  },
  "daily": {
    "time": ["2026-01-16", "2026-01-17", ...],
    "temperature_2m_max": [20.5, 21.3, ...],
    "temperature_2m_min": [10.2, 11.5, ...],
    "weathercode": [0, 1, ...],
    "sunrise": ["2026-01-16T07:45:00", ...],
    "sunset": ["2026-01-16T17:30:00", ...]
  }
}
```

**Parameter-Erklärungen:**
- `latitude` & `longitude` - GPS-Koordinaten (erforderlich)
- `current` - Aktuelle Wetterdaten
- `hourly` - Stündliche Vorhersage (nächste 24h)
- `daily` - Tägliche Vorhersage (7 Tage)
- `timezone=auto` - Automatische Zeitzone basierend auf Koordinaten
- `forecast_days=7` - Anzahl der Vorhersage-Tage

### Wettercodes - Vollständige Referenz

| Code | Bedingung | Tag-Icon | Nacht-Icon | Beschreibung |
|------|-----------|----------|------------|--------------|
| 0 | Klar | ☀️ sun.max.fill | 🌙 moon.stars.fill | Sonnig |
| 1 | Teilweise bewölkt | ⛅ cloud.sun.fill | 🌙☁️ cloud.moon.fill | Teilweise bewölkt |
| 2 | Teilweise bewölkt | ⛅ cloud.sun.fill | 🌙☁️ cloud.moon.fill | Teilweise bewölkt |
| 3 | Bewölkt | ☁️ cloud.fill | ☁️ cloud.fill | Bewölkt |
| 45 | Nebel | 🌫️ cloud.fog.fill | 🌫️ cloud.fog.fill | Nebelig |
| 48 | Nebel | 🌫️ cloud.fog.fill | 🌫️ cloud.fog.fill | Nebelig |
| 51-55 | Nieselregen | 🌦️ cloud.drizzle.fill | 🌦️ cloud.drizzle.fill | Nieselregen |
| 56-57 | Eisregen | 🌦️ cloud.drizzle.fill | 🌦️ cloud.drizzle.fill | Eisregen |
| 61-65 | Regen | 🌧️ cloud.rain.fill | 🌧️ cloud.rain.fill | Regen |
| 66-67 | Gefrierender Regen | 🌧️ cloud.rain.fill | 🌧️ cloud.rain.fill | Gefrierender Regen |
| 71-77 | Schnee | ❄️ cloud.snow.fill | ❄️ cloud.snow.fill | Schnee |
| 80-82 | Starkregen | ⛈️ cloud.heavyrain.fill | ⛈️ cloud.heavyrain.fill | Starker Regen |
| 85-86 | Schneeschauer | 🌨️ cloud.snow.fill | 🌨️ cloud.snow.fill | Schneeschauer |
| 95 | Gewitter | ⚡ cloud.bolt.rain.fill | ⚡ cloud.bolt.rain.fill | Gewitter |
| 96-99 | Gewitter | ⚡ cloud.bolt.rain.fill | ⚡ cloud.bolt.rain.fill | Gewitter |

### SwiftData Schema

#### SavedLocation Model
```swift
@Model
final class SavedLocation {
    // Eindeutige ID
    var id: UUID
    
    // Standort-Informationen
    var name: String                  // z.B. "Berlin"
    var latitude: Double              // GPS-Koordinate
    var longitude: Double             // GPS-Koordinate
    
    // Flags
    var isCurrentLocation: Bool       // true = aktueller GPS-Standort
    
    // Metadaten
    var createdAt: Date              // Erstellungszeitpunkt
    
    init(name: String, latitude: Double, longitude: Double, isCurrentLocation: Bool = false) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isCurrentLocation = isCurrentLocation
        self.createdAt = Date()
    }
}
```

**Query-Beispiel:**
```swift
@Query(sort: \SavedLocation.createdAt) private var savedLocations: [SavedLocation]
```

### iOS 26 Liquid Glass Design

#### Glass Effect Modifier
```swift
.glassEffect(
    .regular                          // Glass-Stil
        .tint(.blue.opacity(0.2))     // Farb-Tönung
        .interactive(),               // Touch-Reaktion
    in: .rect(cornerRadius: 24)       // Shape
)
```

**Verfügbare Stile:**
- `.regular` - Standard-Glas-Effekt
- `.thick` - Dickeres Glas
- `.thin` - Dünneres Glas

**Tinting:**
- `.tint(Color)` - Färbt das Glas
- Opacity 0.1-0.3 für subtile Effekte
- Wetter-basierte Farben (Sonne = Orange, Regen = Blau)

**Interactive Mode:**
- Reagiert auf Touch
- Scales & Highlights bei Interaktion
- Haptic Feedback integriert

### Performance-Optimierungen

#### Lazy Loading
```swift
// Location-Cards laden Wetter asynchron
.task {
    await loadWeather()
}
```

#### Debouncing für Suche
```swift
// Verhindert zu viele API-Calls während Tippen
.onChange(of: searchText) { oldValue, newValue in
    // Filtert lokale Liste, kein API-Call
}
```

#### Auto-Refresh Timer
```swift
// Aktualisiert alle 10 Minuten
Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
    refreshWeather()
}
```

#### Caching mit SwiftData
- Standorte werden lokal gespeichert
- Kein API-Call für bereits geladene Städte
- Schneller App-Start

### Error Handling

#### Location Errors
```swift
switch locationManager.authorizationStatus {
case .notDetermined:
    // Zeige Permission-Dialog
case .denied:
    // Zeige Fehlermeldung
    locationError = "Standortzugriff verweigert"
case .authorizedWhenInUse:
    // Lade Location
}
```

#### API Errors
```swift
do {
    let response = try await WeatherService.shared.fetchWeather(...)
} catch {
    print("Fehler beim Laden: \(error)")
    // Zeige Error-State
}
```

#### Retry-Mechanismus
```swift
// Versuche mehrmals Location zu bekommen
var attempts = 0
while attempts < maxAttempts {
    if let location = locationManager.currentLocation {
        return // Erfolg
    }
    try? await Task.sleep(for: .milliseconds(500))
    attempts += 1
}
// Fallback zu Default-Location
```

## 🌍 Vordefinierte Städte-Datenbank

Die App enthält **100+ Städte** weltweit, kategorisiert nach Regionen:

### Deutschland (10 Städte)
```
Berlin, München, Hamburg, Köln, Frankfurt am Main,
Stuttgart, Düsseldorf, Dortmund, Leipzig, Dresden
```

### Europa (20 Städte)
```
London 🇬🇧, Paris 🇫🇷, Rom 🇮🇹, Madrid 🇪🇸, Barcelona 🇪🇸,
Amsterdam 🇳🇱, Wien 🇦🇹, Zürich 🇨🇭, Prag 🇨🇿, Warschau 🇵🇱,
Kopenhagen 🇩🇰, Stockholm 🇸🇪, Oslo 🇳🇴, Helsinki 🇫🇮,
Brüssel 🇧🇪, Dublin 🇮🇪, Lissabon 🇵🇹, Athen 🇬🇷,
Istanbul 🇹🇷, Ankara 🇹🇷
```

### Naher Osten (14 Städte)
```
Dubai 🇦🇪, Abu Dhabi 🇦🇪, Doha 🇶🇦,
Riad 🇸🇦, Jeddah 🇸🇦,
Tel Aviv 🇮🇱, Jerusalem 🇮🇱,
Beirut 🇱🇧, Amman 🇯🇴, Kuwait 🇰🇼,
Damaskus 🇸🇾, Bagdad 🇮🇶, Kairo 🇪🇬
```

### Asien (10 Städte)
```
Tokyo 🇯🇵, Peking 🇨🇳, Shanghai 🇨🇳,
Hongkong 🇭🇰, Singapur 🇸🇬, Seoul 🇰🇷,
Bangkok 🇹🇭, Mumbai 🇮🇳, Delhi 🇮🇳, Manila 🇵🇭
```

### Amerika (11 Städte)
```
New York 🇺🇸, Los Angeles 🇺🇸, Chicago 🇺🇸,
Miami 🇺🇸, San Francisco 🇺🇸, Washington 🇺🇸,
Toronto 🇨🇦, Mexiko-Stadt 🇲🇽,
Buenos Aires 🇦🇷, São Paulo 🇧🇷, Rio de Janeiro 🇧🇷
```

### Ozeanien (3 Städte)
```
Sydney 🇦🇺, Melbourne 🇦🇺, Auckland 🇳🇿
```

### Afrika (6 Städte)
```
Kapstadt 🇿🇦, Johannesburg 🇿🇦,
Lagos 🇳🇬, Nairobi 🇰🇪, Casablanca 🇲🇦
```

**Suchmöglichkeiten:**
- Nach Stadtname suchen (z.B. "Berlin")
- Nach Land suchen (z.B. "Deutschland")
- Echtzeit-Filterung während Tippen
- Alphabetisch sortiert

## 🔮 Roadmap & Mögliche Erweiterungen

### Phase 1: Erweiterte Wetterdaten (v2.0)
- [ ] **Luftfeuchtigkeit** - Relative Feuchtigkeit in %
- [ ] **Windgeschwindigkeit** - In km/h mit Richtung
- [ ] **Windrichtung** - Visuell mit Kompass-Icon
- [ ] **UV-Index** - Mit Warnstufen (Niedrig, Mittel, Hoch, Sehr hoch)
- [ ] **Luftqualität (AQI)** - Air Quality Index
- [ ] **Niederschlagswahrscheinlichkeit** - In % für jeden Tag
- [ ] **Sichtweite** - In Kilometern
- [ ] **Luftdruck** - In hPa
- [ ] **Taupunkt** - Gefühlte Temperatur
- [ ] **Wolkendecke** - In % Bewölkung

**Implementierung:**
```swift
// Open-Meteo unterstützt bereits diese Parameter:
&current=windspeed_10m,winddirection_10m,uv_index,precipitation_probability
```

### Phase 2: Datenvisualisierung (v2.1)
- [ ] **Swift Charts Integration** - Native Diagramme
- [ ] **Temperaturverlauf-Chart** - 24h Graph
- [ ] **Niederschlags-Balkendiagramm** - 7-Tage-Übersicht
- [ ] **Wind-Rosendiagramm** - Windrichtungs-Verteilung
- [ ] **3D-Charts** - Interaktive 3D-Visualisierung
- [ ] **Animierte Übergänge** - Smooth Chart-Animationen

**Beispiel-Code:**
```swift
import Charts

Chart(hourlyData) { item in
    LineMark(
        x: .value("Zeit", item.time),
        y: .value("Temp", item.temperature)
    )
    .interpolationMethod(.catmullRom)
    .foregroundStyle(.orange.gradient)
}
```

### Phase 3: Widgets & Live Activities (v2.2)
- [ ] **Home Screen Widgets** - Klein, Mittel, Groß
- [ ] **Lock Screen Widgets** - Circular & Rectangular
- [ ] **StandBy Mode** - Volle Bildschirm-Widgets
- [ ] **Live Activities** - Echtzeit-Wetter in Dynamic Island
- [ ] **Interactive Widgets** - Standort wechseln ohne App öffnen
- [ ] **Widget-Personalisierung** - Farben, Daten auswählen

**Widget-Typen:**
- **Klein:** Aktuelle Temperatur + Icon
- **Mittel:** + 3-Stunden-Vorhersage
- **Groß:** + 7-Tage-Übersicht
- **Lock Screen:** Temperatur + Symbol

### Phase 4: Benachrichtigungen (v2.3)
- [ ] **Push Notifications** - Lokal & Remote
- [ ] **Tägliche Wettervorhersage** - Morgens um 7:00
- [ ] **Extreme Wetter-Warnungen** - Unwetter-Alerts
- [ ] **Regen-Benachrichtigungen** - "Es regnet in 30 Minuten"
- [ ] **Temperatur-Schwellwerte** - Alerts bei >30°C oder <0°C
- [ ] **Outfit-Reminder** - "Vergiss nicht deine Jacke!"

**UNUserNotificationCenter Integration:**
```swift
let content = UNMutableNotificationContent()
content.title = "Wetter-Alert"
content.body = "Gewitter in deiner Nähe!"
```

### Phase 5: Personalisierung (v2.4)
- [ ] **Farbthemen** - Hell, Dunkel, Farbig, Minimal
- [ ] **Einheiten-Umschaltung** - °C ↔ °F, km/h ↔ mph
- [ ] **12/24h Format** - Zeit-Format wählbar
- [ ] **Bevorzugte Startseite** - Welcher Standort beim Start
- [ ] **Daten-Toggles** - Welche Daten anzeigen
- [ ] **Widget-Editor** - Widgets selbst gestalten
- [ ] **App-Icon-Auswahl** - Alternative Icons

### Phase 6: Apple Intelligence Integration (v2.5)
- [ ] **Siri Shortcuts** - "Wie wird das Wetter?"
- [ ] **App Intents** - Systemweite Intents
- [ ] **Spotlight-Suche** - Wetter direkt aus Spotlight
- [ ] **Visual Intelligence** - Kamera-basierte Wetter-Erkennung
- [ ] **Predictive Suggestions** - Proaktive Vorschläge
- [ ] **On-Device LLM** - Foundation Models für Wetter-Zusammenfassungen

**App Intent Beispiel:**
```swift
struct GetWeatherIntent: AppIntent {
    static var title: LocalizedStringResource = "Wetter abrufen"
    
    func perform() async throws -> some IntentResult {
        // Wetter-Daten laden
    }
}
```

### Phase 7: Social Features (v2.6)
- [ ] **Wetter teilen** - Social Media Integration
- [ ] **Foto mit Wetter-Overlay** - Temperatur + Icon auf Fotos
- [ ] **Community Weather Reports** - User-generierte Berichte
- [ ] **Wetter-Storys** - Wie Instagram Stories
- [ ] **Freunde-Standorte** - Wetter von Freunden sehen
- [ ] **Wetter-Vergleich** - 2 Städte vergleichen

### Phase 8: visionOS Support (v2.7)
- [ ] **Native visionOS App** - Spatial Computing
- [ ] **3D-Wetter-Modelle** - Interaktive Wolken
- [ ] **Spatial Widgets** - Widgets im Raum platzieren
- [ ] **Immersive Experiences** - Vollständige Umgebungen
- [ ] **Hand Tracking** - Wetter-Interaktion mit Händen
- [ ] **Eye Tracking** - Blick-basierte Navigation

### Phase 9: Apple Watch (v2.8)
- [ ] **watchOS App** - Standalone Watch App
- [ ] **Komplikationen** - Alle Styles (Circular, Rectangular, etc.)
- [ ] **Always-On Display** - Wetter auf dem Handgelenk
- [ ] **Haptic Alerts** - Vibrations-Benachrichtigungen
- [ ] **Workout Integration** - Wetter während Training
- [ ] **Siri Watch Face** - Proaktive Wetter-Infos

### Phase 10: Erweiterte Features (v3.0)
- [ ] **Historische Daten** - Wetter-Verlauf anzeigen
- [ ] **Vergleich mit Vorjahr** - "Letztes Jahr um diese Zeit..."
- [ ] **Reise-Planer** - Wetter für Reiseziele
- [ ] **Multi-Location View** - Mehrere Städte gleichzeitig
- [ ] **Radar-Ansicht** - Niederschlags-Radar
- [ ] **Satelliten-Bilder** - Live Satelliten-Ansicht
- [ ] **Wetter-Kamera** - AR-Overlay in Kamera
- [ ] **Offline-Modus** - Cached Weather Data

### Phase 11: Premium Features (Optional)
- [ ] **Pro-Abonnement** - Erweiterte Features
- [ ] **Stündliche Benachrichtigungen** - Mehr Granularität
- [ ] **Erweiterte Diagramme** - 14-Tage-Vorhersage
- [ ] **Ad-free Experience** - Keine Werbung
- [ ] **Priority Support** - Premium-Support
- [ ] **Custom Branding** - Eigene Farben & Logos

**Monetarisierung:**
- Free Tier: Basis-Features
- Pro Tier: €2.99/Monat oder €19.99/Jahr
- Lifetime: €49.99 einmalig

## 🐛 Fehlerbehebung & Troubleshooting

### Location-Probleme

#### Problem: "Location nicht verfügbar" / "Standort wird nicht erkannt"

**Mögliche Ursachen & Lösungen:**

1. **Berechtigung nicht erteilt**
   - **Lösung:** Einstellungen → Datenschutz & Sicherheit → Ortungsdienste
   - Stelle sicher, dass "Ortungsdienste" aktiviert ist
   - Scrolle zu "Wetter App" → Wähle "App während Verwendung"

2. **Info.plist fehlt**
   - **Lösung:** Prüfe, dass `NSLocationWhenInUseUsageDescription` in Info.plist vorhanden ist
   - Neu kompilieren nach Hinzufügen

3. **GPS-Signal schwach**
   - **Lösung:** Gehe nach draußen oder an ein Fenster
   - Warte 10-30 Sekunden für GPS-Fix
   - Flugmodus aus- und einschalten

4. **Simulatoren-Problem**
   - **Lösung:** Im Simulator: Features → Location → Custom Location
   - Setze Koordinaten (z.B. Berlin: 52.52, 13.405)

**Debugging-Schritte:**
```swift
// Überprüfe Authorization Status in Console:
print("Auth Status: \(locationManager.authorizationStatus)")

// Erwartete Werte:
// - .notDetermined (0) → Noch nicht gefragt
// - .restricted (1) → Systemseitig blockiert
// - .denied (2) → User hat abgelehnt
// - .authorizedWhenInUse (3) → ✅ OK
```

#### Problem: "Standortname wird nicht angezeigt" / "Lädt ewig"

**Lösungen:**
1. **Internetverbindung prüfen** - Reverse Geocoding benötigt Internet
2. **MapKit-Berechtigung** - Automatisch mit Location-Berechtigung
3. **Fallback greift** - App zeigt "Aktueller Standort" wenn Geocoding fehlschlägt

#### Problem: "App springt immer zu Amman"

**Ursache:** Fallback-Location wird verwendet wenn GPS fehlschlägt

**Lösungen:**
1. Location-Berechtigung erneut erteilen
2. App neu installieren (Reset aller Berechtigungen)
3. Warte länger (bis zu 5 Sekunden für GPS-Fix)

### Wetter-Probleme

#### Problem: "Wetter wird nicht geladen" / "Daten erscheinen nicht"

**Mögliche Ursachen:**

1. **Keine Internetverbindung**
   - **Lösung:** WLAN/Mobilfunk aktivieren
   - Teste Internetverbindung in Safari

2. **API temporär nicht verfügbar**
   - **Lösung:** Warte 1-2 Minuten und tippe "Aktualisieren"
   - Open-Meteo hat sehr hohe Verfügbarkeit (99.9%)

3. **Ungültige Koordinaten**
   - **Lösung:** Lösche Standort und füge ihn neu hinzu
   - Prüfe, dass Lat/Lon im gültigen Bereich (-90 bis 90, -180 bis 180)

4. **App im Offline-Modus**
   - **Lösung:** Flugmodus deaktivieren
   - Low Data Mode in Einstellungen deaktivieren

**Debugging:**
```swift
// Console-Output prüfen:
"✅ Location gefunden: 52.52, 13.405"  // GPS erfolgreich
"📡 HTTP Status: 200"                   // API erfolgreich
"❌ Fehler beim Laden: ..."             // Fehlermeldung
```

#### Problem: "Falsche Temperatur angezeigt"

**Ursachen:**
1. **Alte Daten** - API aktualisiert stündlich
2. **Falsche Zeitzone** - `timezone=auto` sollte das lösen
3. **Cache-Problem** - App neu starten

**Lösungen:**
- Tippe auf "Aktualisieren" (⟳)
- Warte 10 Minuten für Auto-Refresh
- App neu starten

#### Problem: "Icons passen nicht zum Wetter"

**Überprüfung:**
1. Ist es Tag oder Nacht? Icons ändern sich!
   - Tag: ☀️ sun.max.fill
   - Nacht: 🌙 moon.stars.fill

2. Stimmen Sonnenauf-/Untergangszeiten?
   - Prüfe in API-Response (Console)
   - Fallback: 18:00-06:00 = Nacht

### SwiftData-Probleme

#### Problem: "Standorte werden nicht gespeichert"

**Lösungen:**

1. **App neu starten**
   - Schließe App vollständig (Swipe up in App-Switcher)
   - Öffne App erneut

2. **ModelContainer überprüfen**
   ```swift
   // In App-Datei:
   .modelContainer(for: SavedLocation.self)
   ```

3. **App neu installieren** (löscht alle Daten!)
   - Halte App-Icon gedrückt → "App entfernen"
   - Neu aus Xcode installieren

4. **Simulator zurücksetzen**
   - Simulator → Device → Erase All Content and Settings

#### Problem: "Gelöschte Standorte kommen zurück"

**Ursache:** ModelContext wurde nicht gesaved

**Lösung:**
```swift
// Nach delete immer:
try modelContext.save()
```

#### Problem: "Swipe-to-Delete funktioniert nicht"

**Überprüfung:**
- Ist es der aktuelle GPS-Standort? Der kann NICHT gelöscht werden!
- `isCurrentLocation == true` → Swipe-Action wird nicht angezeigt

### UI/UX-Probleme

#### Problem: "App ist langsam" / "Animationen ruckeln"

**Optimierungen:**

1. **Zu viele Standorte** (>20)
   - Lösche ungenutzte Standorte
   - Lazy Loading greift automatisch

2. **Gerät überlastet**
   - Schließe andere Apps
   - iPhone neu starten

3. **Debug-Build**
   - Release-Build ist deutlich schneller
   - Product → Archive für Optimierung

#### Problem: "Glassmorphism-Effekte werden nicht angezeigt"

**Voraussetzungen:**
- iOS 18+ für `.glassEffect()`
- Ältere iOS-Versionen: Fallback zu Standard-Background

**Lösung:**
- Update auf neueste iOS-Version
- Oder: Ersetze `.glassEffect()` durch `.background(.ultraThinMaterial)`

#### Problem: "Kleidungsempfehlungen fehlen"

**Überprüfung:**
1. Tippe auf T-Shirt-Icon (👕) oben rechts
2. Sheet sollte sich öffnen
3. Falls nicht: App neu starten

#### Problem: "Haptic Feedback funktioniert nicht"

**Ursachen:**
- Haptisches Feedback in Systemeinstellungen deaktiviert
- Simulator (Haptics werden nicht simuliert)
- Gerät unterstützt keine Haptics (sehr alte iPhones)

**Lösung:**
- Teste auf echtem Gerät (iPhone 7+)
- Einstellungen → Töne & Haptik → Systemhaptik aktivieren

### API-spezifische Probleme

#### Problem: "Rate Limit erreicht" (sehr selten)

**Open-Meteo:**
- Kein echtes Rate-Limit für nicht-kommerzielle Nutzung
- Bei Missbrauch: 10.000 Requests/Tag Limit

**Lösung:**
- Warte 10-15 Minuten
- App implementiert Auto-Refresh alle 10 Minuten (OK)

#### Problem: "JSON Parsing Error"

**Debugging:**
```swift
// Console zeigt:
"❌ JSON Decodierung fehlgeschlagen: ..."

// Überprüfe API-Response:
if let jsonString = String(data: data, encoding: .utf8) {
    print(jsonString)
}
```

**Lösungen:**
1. API-Format hat sich geändert → Update App
2. Netzwerk-Problem → Neu probieren
3. Ungültige Koordinaten → Standort neu hinzufügen

### Allgemeine Tipps

#### Reset-Optionen

1. **Soft Reset** (erhält Daten)
   ```
   App schließen → Neu öffnen
   ```

2. **Cache löschen** (erhält Standorte)
   ```
   Einstellungen → Allgemein → iPhone-Speicher
   → Wetter App → Offload App
   ```

3. **Hard Reset** (löscht ALLES)
   ```
   App deinstallieren → Neu installieren
   ```

#### Debug-Logs aktivieren

In `WeatherService.swift` und `LocationManager.swift`:
```swift
// Füge print-Statements hinzu:
print("🔍 DEBUG: \(variable)")
```

#### Xcode Console überwachen

**Wichtige Log-Marker:**
- ✅ = Erfolg
- ⚠️ = Warnung
- ❌ = Fehler
- 🔄 = Automatische Aktualisierung
- 📡 = API-Call
- 📍 = Location-Update

### Bekannte Einschränkungen

1. **Location-Genauigkeit**
   - `kCLLocationAccuracyKilometer` für Battery-Saving
   - Für genauere Location: `kCLLocationAccuracyBest` verwenden

2. **API-Daten-Verzögerung**
   - Open-Meteo aktualisiert stündlich
   - Nicht Echtzeit, sondern "near real-time"

3. **Keine Weltweite Suche**
   - Nur vordefinierte 100+ Städte
   - Für mehr: Nominatim-Integration implementieren (Phase 1)

4. **iOS 16+ erforderlich**
   - SwiftData benötigt iOS 17+
   - Für iOS 16: Verwende Core Data statt SwiftData

### Support kontaktieren

Falls alle Lösungen fehlschlagen:

1. **GitHub Issue öffnen**
   - https://github.com/yourusername/wetter-app/issues
   - Beschreibe Problem detailliert
   - Füge Console-Logs hinzu

2. **Email senden**
   - support@example.com
   - Screenshot hinzufügen
   - iOS-Version & iPhone-Modell angeben

3. **Crash-Reports**
   - Xcode → Window → Organizer → Crashes
   - Sende Crash-Log mit

## 📝 API-Lizenzen & Attribution

### Open-Meteo Weather API

**Website:** https://open-meteo.com

**Lizenz:** CC BY 4.0 (Creative Commons Attribution 4.0 International)

**Nutzungsbedingungen:**
- ✅ **Kostenlos** für nicht-kommerzielle Nutzung
- ✅ **Keine Registrierung** erforderlich
- ✅ **Unbegrenzte Requests** für private Apps
- ⚠️ **Attribution erforderlich** für kommerzielle Nutzung
- ⚠️ **Rate Limit:** 10.000 Requests/Tag bei kommerziellem Gebrauch

**Kommerzielle Nutzung:**
```
Wenn du diese App kommerziell nutzen möchtest:
1. Füge "Weather data by Open-Meteo.com" hinzu
2. Oder: Upgrade auf Open-Meteo API Subscription
3. Details: https://open-meteo.com/en/pricing
```

**API-Dokumentation:**
- Forecast API: https://open-meteo.com/en/docs
- Historical Weather: https://open-meteo.com/en/docs/historical-weather-api
- Air Quality: https://open-meteo.com/en/docs/air-quality-api

**Data Sources:**
- NOAA (National Oceanic and Atmospheric Administration)
- DWD (Deutscher Wetterdienst)
- MeteoFrance
- ECMWF (European Centre for Medium-Range Weather Forecasts)

### SF Symbols (Apple)

**Lizenz:** Apple Design Resources License Agreement

**Nutzungsbedingungen:**
- ✅ **Kostenlos** für Apps auf Apple-Plattformen
- ✅ **Nur auf iOS, iPadOS, macOS, watchOS, tvOS, visionOS**
- ❌ **NICHT auf Android, Web oder Windows**
- ✅ **Kommerzielle Nutzung erlaubt** auf Apple-Plattformen

**Verwendete Symbole:**
- `sun.max.fill`, `moon.stars.fill` - Wetter-Icons
- `cloud.sun.fill`, `cloud.rain.fill` - Wetter-Zustände
- `location.fill`, `location.circle.fill` - Location-Icons
- `tshirt.fill` - Kleidungsempfehlungen
- `plus.circle.fill` - Hinzufügen-Aktion

**Dokumentation:**
- SF Symbols App: https://developer.apple.com/sf-symbols/
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/sf-symbols

### MapKit & Core Location (Apple)

**Lizenz:** Apple SDK Agreement

**Nutzungsbedingungen:**
- ✅ Kostenlos für alle Apple-Entwickler
- ✅ Reverse Geocoding ohne Limits
- ⚠️ Respektiere User-Privacy

**Privacy-Anforderungen:**
- ✅ `NSLocationWhenInUseUsageDescription` in Info.plist
- ✅ Klare Kommunikation warum Location benötigt wird
- ✅ Minimale Location-Genauigkeit (`kCLLocationAccuracyKilometer`)
- ✅ Keine Location-Tracking ohne Grund

## 🔒 Datenschutz & Privacy

### Datenerhebung

**Was wird gesammelt:**
1. **GPS-Koordinaten**
   - Nur wenn Location-Berechtigung erteilt
   - Nur während App-Nutzung
   - Wird NICHT auf Server hochgeladen

2. **Gespeicherte Standorte**
   - Lokal in SwiftData (on-device)
   - Stadtname + Koordinaten
   - Erstellungsdatum

3. **Wetterdaten**
   - Von Open-Meteo API
   - Nur basierend auf angefragten Koordinaten
   - Keine persönlichen Informationen

**Was wird NICHT gesammelt:**
- ❌ Keine Benutzer-Accounts
- ❌ Keine Email-Adressen
- ❌ Keine Analyse-Tools (Analytics)
- ❌ Keine Crash-Reports an Dritte
- ❌ Keine Werbe-Tracker
- ❌ Keine Location-History

### Datenverarbeitung

**Lokal (On-Device):**
- ✅ Alle Standorte in SwiftData
- ✅ Preferences & Settings
- ✅ Cache für Wetterdaten

**Externe API-Calls:**
- **Open-Meteo:**
  - `GET https://api.open-meteo.com/v1/forecast?latitude=XX&longitude=XX`
  - Keine User-Identifikation
  - Keine Cookies
  - IP-Adresse wird von Server gesehen (technisch notwendig)

- **MapKit Reverse Geocoding:**
  - Apple-Server für Standortnamen
  - Anonymisiert durch Apple
  - Apple Privacy Policy gilt

### DSGVO-Konformität

**Für EU-Nutzer:**
- ✅ Keine Cookies
- ✅ Keine Datenübertragung an Dritte (außer API)
- ✅ Lokale Datenspeicherung
- ✅ Recht auf Löschung (App deinstallieren = alle Daten weg)
- ✅ Transparente Datennutzung

**Privacy Policy (Beispiel):**
```
Diese App:
1. Speichert deine Standorte lokal auf deinem Gerät
2. Sendet GPS-Koordinaten an Open-Meteo.com für Wetterdaten
3. Teilt KEINE persönlichen Daten mit Dritten
4. Nutzt keine Werbe-Tracker oder Analytics
```

### Best Practices implementiert

1. **Minimale Berechtigungen**
   - Nur `WhenInUse` Location (nicht `Always`)
   - Keine Hintergrund-Location

2. **Privacy-freundliche Defaults**
   - Location-Accuracy auf Kilometer (nicht Best)
   - Keine Standort-Verfolgung

3. **Transparente Kommunikation**
   - Klare Usage-Description in Permission-Dialog
   - Hilfreiche Fehlermeldungen

4. **User-Kontrolle**
   - User kann Location-Berechtigung jederzeit widerrufen
   - App funktioniert auch ohne GPS (manuelle Städte-Auswahl)

## 💻 Entwickler-Hinweise

### Projekt klonen & setup

```bash
# Repository klonen
git clone https://github.com/yourusername/wetter-app.git
cd wetter-app

# Xcode öffnen
open WetterApp.xcodeproj

# Dependencies installieren (falls vorhanden)
# Dieses Projekt hat KEINE externen Dependencies!
```

### Build & Run

1. **Simulator auswählen**
   - Product → Destination → iPhone 15 Pro (oder anderes)

2. **Build & Run**
   - `Cmd + R`
   - Oder: Play-Button in Xcode

3. **Custom Location im Simulator setzen**
   - Features → Location → Custom Location
   - Beispiel Berlin: Lat `52.52`, Lon `13.405`

### Code-Struktur

```
ContentView.swift (1877 Zeilen)
├── SwiftData Models
│   └── SavedLocation
├── API Models
│   ├── WeatherResponse
│   ├── CurrentWeather
│   ├── DailyWeather
│   └── HourlyWeather
├── View Models
│   ├── WeatherData
│   ├── ClothingItem
│   ├── TemperatureFeeling
│   ├── DayForecast
│   └── HourlyForecast
├── Services (@Observable)
│   ├── WeatherService
│   ├── LocationManager
│   └── GeocodingService
└── Views
    ├── ContentView (Main)
    ├── LocationCard
    ├── AddLocationView
    ├── ClothingRecommendationView
    ├── ClothingIconButton
    └── ClothingDetailSheet
```

### Testing

**Manual Testing Checklist:**
- [ ] Location-Berechtigung funktioniert
- [ ] GPS-Standort wird erkannt
- [ ] Wetterdaten laden korrekt
- [ ] Standort hinzufügen funktioniert
- [ ] Swipe-to-Delete funktioniert
- [ ] Kleidungsempfehlungen erscheinen
- [ ] Auto-Refresh alle 10 Minuten
- [ ] Tag/Nacht-Icons korrekt
- [ ] Glassmorphism-Effekte sichtbar
- [ ] Haptic Feedback funktioniert

**Unit Tests (TODO):**
```swift
import Testing

@Test("Weather Code to Icon Conversion")
func testWeatherCodeConversion() {
    let service = WeatherService.shared
    
    // Tag-Icons
    #expect(service.weatherCodeToIcon(0, isNightTime: false) == "sun.max.fill")
    #expect(service.weatherCodeToIcon(61, isNightTime: false) == "cloud.rain.fill")
    
    // Nacht-Icons
    #expect(service.weatherCodeToIcon(0, isNightTime: true) == "moon.stars.fill")
}
```

### Contribution Guidelines

1. **Fork das Repo**
2. **Feature Branch erstellen**
   ```bash
   git checkout -b feature/amazing-new-feature
   ```

3. **Code schreiben**
   - Folge Swift Style Guide
   - Kommentiere komplexe Logik
   - Verwende `// MARK:` für Sections

4. **Commit**
   ```bash
   git commit -m "Add: Amazing new feature"
   ```

5. **Push & Pull Request**
   ```bash
   git push origin feature/amazing-new-feature
   ```

### Code-Style

**Swift Naming Conventions:**
- `UpperCamelCase` für Types (Classes, Structs, Enums)
- `lowerCamelCase` für Functions, Variables, Constants
- `SCREAMING_SNAKE_CASE` vermeiden (nicht Swift-idiomatisch)

**MARK-Comments verwenden:**
```swift
// MARK: - Properties
// MARK: - Lifecycle
// MARK: - Actions
// MARK: - Helper Methods
```

**SwiftUI Best Practices:**
- Komponenten < 300 Zeilen (sonst aufspalten)
- `@ViewBuilder` für komplexe Views
- `private` für Helper-Methods
- `extension` für View-Modifiers

---

**Viel Erfolg mit der Wetter-App! 🌤️**

**Made with ❤️ and Swift**

Bei Fragen: [GitHub Discussions](https://github.com/yourusername/wetter-app/discussions)


