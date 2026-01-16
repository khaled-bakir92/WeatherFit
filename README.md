# 🌤️ WeaterFit App

Eine moderne, kostenlose Wetter-App für iOS mit SwiftUI, SwiftData und iOS 26 Liquid Glass Design.

<p align="center">
  <img src="https://img.shields.io/badge/iOS-16.0+-blue.svg" alt="iOS 16.0+">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/SwiftUI-✓-green.svg" alt="SwiftUI">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="MIT License">
</p>

## 📱 Features

### 🌍 Standortverwaltung
- ✅ **Automatische Standorterkennung** mit Core Location
- ✅ **Weltweite Städtesuche** mit über 100 vordefinierten Städten
- ✅ **Gespeicherte Standorte** mit SwiftData Persistenz
- ✅ **Reverse Geocoding** für automatische Standortnamen
- ✅ **Swipe-to-Delete** für gespeicherte Standorte
- ✅ **Schnellzugriff** auf aktuellen Standort über Toolbar

### 🌦️ Wetterdaten
- ✅ **Aktuelle Wetterdaten** in Echtzeit
- ✅ **7-Tage-Vorhersage** mit visuellen Temperatur-Balken
- ✅ **Stündliche Vorhersage** für den heutigen Tag
- ✅ **Tag/Nacht-Modi** - unterschiedliche Icons für Tag und Nacht
- ✅ **Sonnenauf- und Untergangszeiten** werden berücksichtigt
- ✅ **Wettercode-Interpretation** mit 11 verschiedenen Wetterzuständen
- ✅ **Automatische Aktualisierung** alle 10 Minuten
- ✅ **Kostenlose API** - keine API-Keys erforderlich (Open-Meteo)

### 👕 Kleidungsempfehlungen 
- ✅ **Intelligente Outfit-Vorschläge** basierend auf Temperatur
- ✅ **Temperatur-Klassifizierung** - 7 Stufen von "Sehr Kalt" bis "Sehr Heiß"
- ✅ **Wetter-spezifische Empfehlungen** - berücksichtigt Regen, Schnee, Wind
- ✅ **Detaillierte Erklärungen** für jedes Kleidungsstück
- ✅ **Farbcodierte Temperatur-Badges** für schnelle Orientierung
- ✅ **Interaktive Kleidungs-Icons** mit Haptic Feedback

### 🎨 Modernes Design
- ✅ **iOS 26 Liquid Glass Design** mit interaktiven Effekten
- ✅ **Glassmorphism-Effekte** für moderne UI
- ✅ **Wetter-basierte Farbanpassung** - Cards ändern Farbe je nach Wetter
- ✅ **Smooth Animations** mit Spring-Effekten
- ✅ **Haptic Feedback** für alle Interaktionen
- ✅ **Responsive Layout** - optimiert für alle iPhone-Größen
- ✅ **Farbverlauf-Hintergründe** basierend auf Temperatur

### ⚡️ Technische Features
- ✅ **SwiftUI** - moderne deklarative UI
- ✅ **SwiftData** - lokale Datenpersistenz
- ✅ **Async/Await** - moderne asynchrone Programmierung
- ✅ **@Observable Macro** - State Management
- ✅ **Core Location** - Standorterkennung
- ✅ **MapKit** - Reverse Geocoding
- ✅ **URLSession** - REST API Integration
- ✅ **Error Handling** - Robuste Fehlerbehandlung

## 🚀 Schnellstart

### Voraussetzungen
- Xcode 15.0 oder höher
- iOS 16.0 oder höher
- Swift 6.0

### Installation

1. **Projekt klonen**
```bash
git clone https://github.com/khaled-bakir92/WeatherFit.git
cd weatherFit
```

2. **Xcode öffnen**
```bash
open WetterApp.xcodeproj
```

3. **Info.plist konfigurieren**

Füge folgenden Eintrag in deine `Info.plist` hinzu:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Wir benötigen deinen Standort, um dir das aktuelle Wetter anzuzeigen.</string>
```

Oder im Property List Editor:
- **Key:** Privacy - Location When In Use Usage Description
- **Value:** Wir benötigen deinen Standort, um dir das aktuelle Wetter anzuzeigen.

4. **App starten**
- Wähle ein Simulator oder Device
- Drücke `Cmd + R` zum Bauen und Starten

## 📖 Verwendung

### Erste Schritte
1. App starten
2. Location-Berechtigung erlauben
3. Die App zeigt automatisch das Wetter für deinen aktuellen Standort

### Standorte verwalten
- **Hinzufügen:** Tippe auf das Plus-Icon (➕) → Suche Stadt → Auswählen
- **Wechseln:** Tippe auf eine Standort-Card in der Liste
- **Löschen:** Swipe nach links → Tippe "Löschen"
- **Zurück zum aktuellen Standort:** Tippe auf Location-Icon (📍) oben links

### Kleidungsempfehlungen
1. Tippe auf das T-Shirt-Icon (👕) oben rechts
2. Sehe intelligente Outfit-Vorschläge basierend auf aktuellem Wetter
3. Tippe auf ein Kleidungsstück für detaillierte Erklärung

### Wetter aktualisieren
- Automatisch: Alle 10 Minuten
- Manuell: Tippe auf Aktualisieren-Icon (⟳) in der Toolbar

## 🌍 Unterstützte Städte

Die App enthält über 100 vordefinierte Städte weltweit:

### Deutschland (10 Städte)
Berlin, München, Hamburg, Köln, Frankfurt, Stuttgart, Düsseldorf, Dortmund, Leipzig, Dresden

### Europa (20 Städte)
London, Paris, Rom, Madrid, Barcelona, Amsterdam, Wien, Zürich, Prag, Warschau, Kopenhagen, Stockholm, Oslo, Helsinki, Brüssel, Dublin, Lissabon, Athen, Istanbul, Ankara

### Naher Osten (14 Städte)
Dubai, Abu Dhabi, Doha, Riad, Jeddah, Tel Aviv, Jerusalem, Beirut, Amman, Kuwait, Damaskus, Bagdad, Kairo

### Asien (10 Städte)
Tokyo, Peking, Shanghai, Hongkong, Singapur, Seoul, Bangkok, Mumbai, Delhi, Manila

### Amerika (11 Städte)
New York, Los Angeles, Chicago, Miami, San Francisco, Washington, Toronto, Mexiko-Stadt, Buenos Aires, São Paulo, Rio de Janeiro

### Ozeanien (3 Städte)
Sydney, Melbourne, Auckland

### Afrika (6 Städte)
Kapstadt, Johannesburg, Lagos, Nairobi, Casablanca

## 🎨 Design-System

### Temperatur-Klassifizierung

| Temperatur | Kategorie | Farbe | Emoji |
|-----------|-----------|-------|-------|
| < 0°C | SEHR KALT | Blau | ❄️ |
| 0-8°C | KALT | Blau | 🥶 |
| 9-15°C | KÜHL | Cyan | 🍃 |
| 16-22°C | MILD | Grün | ☀️ |
| 23-29°C | WARM | Orange | 🌤️ |
| 30-34°C | HEISS | Rot | 🔥 |
| 35°C+ | SEHR HEISS | Rot | 🌋 |

### Wettercodes & Icons

| Code | Bedingung | Tag-Icon | Nacht-Icon |
|------|-----------|----------|------------|
| 0 | Sonnig | ☀️ sun.max.fill | 🌙 moon.stars.fill |
| 1-2 | Teilweise bewölkt | ⛅ cloud.sun.fill | 🌙☁️ cloud.moon.fill |
| 3 | Bewölkt | ☁️ cloud.fill | ☁️ cloud.fill |
| 45-48 | Nebelig | 🌫️ cloud.fog.fill | 🌫️ cloud.fog.fill |
| 51-57 | Nieselregen | 🌦️ cloud.drizzle.fill | 🌦️ cloud.drizzle.fill |
| 61-67 | Regen | 🌧️ cloud.rain.fill | 🌧️ cloud.rain.fill |
| 71-77 | Schnee | ❄️ cloud.snow.fill | ❄️ cloud.snow.fill |
| 80-82 | Starker Regen | ⛈️ cloud.heavyrain.fill | ⛈️ cloud.heavyrain.fill |
| 85-86 | Schneeschauer | 🌨️ cloud.snow.fill | 🌨️ cloud.snow.fill |
| 95-99 | Gewitter | ⚡ cloud.bolt.rain.fill | ⚡ cloud.bolt.rain.fill |

## 🔧 Technische Architektur

### Projekt-Struktur
```
WetterApp/
├── Models/
│   ├── SavedLocation.swift          # SwiftData Model
│   ├── WeatherResponse.swift        # API Response Models
│   └── ClothingItem.swift           # Kleidungsempfehlung Models
├── Services/
│   ├── WeatherService.swift         # Wetter-API Service
│   ├── LocationManager.swift        # Core Location Manager
│   └── GeocodingService.swift       # Nominatim Geocoding
├── Views/
│   ├── ContentView.swift            # Haupt-View
│   ├── LocationCard.swift           # Standort-Card Component
│   ├── AddLocationView.swift        # Standort hinzufügen
│   └── ClothingRecommendationView.swift  # Outfit-Empfehlung
└── App/
    └── WetterApp.swift              # App Entry Point
```

### SwiftData Models
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

### API Integration
```swift
// Open-Meteo Weather API
let url = "https://api.open-meteo.com/v1/forecast"
    + "?latitude=\(lat)&longitude=\(lon)"
    + "&current=temperature_2m,weathercode"
    + "&hourly=temperature_2m,weathercode"
    + "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset"
    + "&timezone=auto&forecast_days=7"
```

### State Management
- **@Observable** für LocationManager und WeatherService
- **@Query** für SwiftData-Abfragen
- **@State** für View-lokalen State
- **@Environment** für ModelContext und Dismiss

## 🌐 API-Verwendung

### Open-Meteo Weather API
- **URL:** https://api.open-meteo.com
- **Lizenz:** CC BY 4.0
- **Rate Limit:** Unbegrenzt für nicht-kommerzielle Nutzung
- **Kosten:** Kostenlos
- **Dokumentation:** https://open-meteo.com/en/docs

**Features:**
- Aktuelle Wetterdaten
- 7-Tage-Vorhersage
- Stündliche Daten
- Sonnenauf-/Untergang
- Keine Registrierung erforderlich

## 🎯 Roadmap & Erweiterungen

### Geplante Features

#### v2.0 - Erweiterte Daten
- [ ] Luftfeuchtigkeit
- [ ] Windgeschwindigkeit & Richtung
- [ ] UV-Index
- [ ] Luftqualität
- [ ] Niederschlagswahrscheinlichkeit
- [ ] Sichtweite
- [ ] Luftdruck

#### v2.1 - Visualisierung
- [ ] Temperaturverlauf-Diagramm (Swift Charts)
- [ ] Niederschlagsdiagramm
- [ ] 3D-Wettervisualisierung
- [ ] Animierte Wettereffekte

#### v2.2 - Widgets
- [ ] Home Screen Widget (Klein, Mittel, Groß)
- [ ] Lock Screen Widget
- [ ] StandBy Widget
- [ ] Live Activities für Wetter-Updates
- [ ] Interactive Widgets

#### v2.3 - Benachrichtigungen
- [ ] Wetter-Alerts
- [ ] Tägliche Wettervorhersage (Push)
- [ ] Extreme Wetter-Warnungen
- [ ] Regen-Benachrichtigungen

#### v2.4 - Personalisierung
- [ ] Farbthemen (Hellblau, Dunkel, Farbig)
- [ ] Einheiten umschalten (°C/°F, km/mi)
- [ ] Bevorzugte Startseite
- [ ] Widget-Personalisierung

#### v2.5 - Social Features
- [ ] Wetter teilen (Social Media)
- [ ] Foto-Upload mit Wetter-Overlay
- [ ] Community-Wetter-Reports

#### v2.6 - Apple Intelligence Integration
- [ ] Siri Shortcuts für Wetter-Abfragen
- [ ] App Intents
- [ ] Spotlight-Integration
- [ ] Visual Intelligence

#### v2.7 - visionOS Support
- [ ] Native visionOS App
- [ ] 3D-Wetter-Modelle
- [ ] Spatial Widgets
- [ ] Immersive Weather Experiences

#### v2.8 - Apple Watch
- [ ] watchOS App
- [ ] Komplikationen
- [ ] Standalone-Modus

## 🐛 Bekannte Probleme & Lösungen

### Location-Probleme

**Problem:** "Location nicht verfügbar"
- **Lösung 1:** Prüfe Location-Berechtigung in Einstellungen → Datenschutz → Ortungsdienste
- **Lösung 2:** Stelle sicher, dass `NSLocationWhenInUseUsageDescription` in Info.plist vorhanden ist
- **Lösung 3:** App neu installieren

**Problem:** Standortname wird nicht angezeigt
- **Lösung:** Internetverbindung prüfen (Reverse Geocoding benötigt Internet)

### Wetter-Probleme

**Problem:** Wetter wird nicht geladen
- **Lösung 1:** Internetverbindung prüfen
- **Lösung 2:** Warte 1-2 Sekunden - API kann verzögert antworten
- **Lösung 3:** Tippe auf Aktualisieren-Icon

**Problem:** Falsche Temperatur
- **Lösung:** Open-Meteo API könnte Daten noch aktualisieren - warte 10 Minuten

### SwiftData-Probleme

**Problem:** Standorte werden nicht gespeichert
- **Lösung 1:** App neu starten
- **Lösung 2:** App neu installieren (löscht alle Daten)

## 💡 Best Practices

### Performance-Optimierung
- ✅ Lazy Loading für Standort-Cards
- ✅ Debouncing für API-Calls
- ✅ Rate Limiting für Geocoding
- ✅ Effizientes Caching mit SwiftData
- ✅ Asynchrone Datenladung mit async/await

### User Experience
- ✅ Haptic Feedback für alle Interaktionen
- ✅ Smooth Animationen (Spring-Effekte)
- ✅ Error States mit hilfreichen Nachrichten
- ✅ Loading States mit ProgressView
- ✅ Pull-to-Refresh für manuelle Updates

### Code-Qualität
- ✅ MVVM-ähnliche Architektur
- ✅ Single Responsibility Principle
- ✅ Wiederverwendbare Components
- ✅ Type-Safe API Models
- ✅ Fehlerbehandlung mit do-catch

## 🤝 Beitragen

Contributions sind willkommen! Bitte folge diesen Schritten:

1. Fork das Repository
2. Erstelle einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Committe deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

## 📄 Lizenz
MIT License - Copyright (c) 2026 Khaled Bakir

### Drittanbieter-Lizenzen

**Open-Meteo API:**
- Lizenz: CC BY 4.0
- Attribution erforderlich für kommerzielle Nutzung
- https://open-meteo.com/en/license

**SF Symbols:**
- Apple San Francisco Symbols
- Nur für Apple-Plattformen
- https://developer.apple.com/sf-symbols/

## 👨‍💻 Autor

**Khaled Bakir**
- GitHub: [@khaledbakir](https://github.com/khaled-bakir92)
- Email: khaled.bakir92@gmail.com

## 🙏 Danksagungen

- **Open-Meteo** - Für die kostenlose Wetter-API
- **Apple** - Für SwiftUI, SwiftData und SF Symbols
- **Community** - Für Feedback und Contributions

## 📞 Support

Bei Fragen oder Problemen:
1. Öffne ein [GitHub Issue](https://github.com/khaled-bakir92/WeatherFit/issues)
2. Sende eine Email an support@example.com
3. Diskutiere in [GitHub Discussions](https://github.com/khaled-bakir92/WeatherFit/discussions)

---

**🌤️**


