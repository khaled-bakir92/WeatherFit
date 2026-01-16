//
//  ContentView.swift
//  test liqued
//
//  Created by khaled Bakir on 1/14/26.
//

import SwiftUI
import SwiftData
import CoreLocation
import MapKit
import Contacts

// MARK: - SwiftData Models
@Model
final class SavedLocation {
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var isCurrentLocation: Bool
    var createdAt: Date
    
    init(name: String, latitude: Double, longitude: Double, isCurrentLocation: Bool = false) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isCurrentLocation = isCurrentLocation
        self.createdAt = Date()
    }
}

// MARK: - Weather API Models
struct WeatherResponse: Codable {
    let current: CurrentWeather
    let daily: DailyWeather
    let hourly: HourlyWeather
    
    struct CurrentWeather: Codable {
        let temperature_2m: Double
        let weathercode: Int
        let time: String
    }
    
    struct DailyWeather: Codable {
        let time: [String]
        let weathercode: [Int]
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
        let sunrise: [String]
        let sunset: [String]
    }
    
    struct HourlyWeather: Codable {
        let time: [String]
        let temperature_2m: [Double]
        let weathercode: [Int]
    }
}

// MARK: - View Models
struct WeatherData {
    let temperature: Int
    let condition: String
    let icon: String
    let highTemp: Int
    let lowTemp: Int
}

// MARK: - Clothing Recommendation Models
struct ClothingItem: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let reason: String
    let color: Color
}

enum TemperatureFeeling: String {
    case veryCold = "SEHR KALT"
    case cold = "KALT"
    case cool = "KÜHL"
    case mild = "MILD"
    case warm = "WARM"
    case hot = "HEISS"
    case veryHot = "SEHR HEISS"
    
    var color: Color {
        switch self {
        case .veryCold, .cold:
            return .blue
        case .cool:
            return .cyan
        case .mild:
            return .green
        case .warm:
            return .orange
        case .hot, .veryHot:
            return .red
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .veryCold, .cold:
            return [.blue.opacity(0.3), .cyan.opacity(0.2)]
        case .cool:
            return [.cyan.opacity(0.3), .blue.opacity(0.2)]
        case .mild:
            return [.green.opacity(0.3), .mint.opacity(0.2)]
        case .warm:
            return [.orange.opacity(0.3), .yellow.opacity(0.2)]
        case .hot, .veryHot:
            return [.red.opacity(0.3), .orange.opacity(0.2)]
        }
    }
}

struct DayForecast: Identifiable {
    let id = UUID()
    let day: String
    let icon: String
    let highTemp: Int
    let lowTemp: Int
}

struct HourlyForecast: Identifiable {
    let id = UUID()
    let time: String
    let icon: String
    let temperature: Int
}

// MARK: - Weather Service
@Observable
class WeatherService {
    static let shared = WeatherService()
    
    private init() {}
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        // Open-Meteo API - mit Sonnenaufgang und Sonnenuntergang
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weathercode&hourly=temperature_2m,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto&forecast_days=7"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    // Wettercode zu Icon konvertieren - mit Tag/Nacht Unterstützung
    func weatherCodeToIcon(_ code: Int, isNightTime: Bool = false) -> String {
        // Nacht-spezifische Icons
        if isNightTime {
            switch code {
            case 0: return "moon.stars.fill"
            case 1, 2: return "cloud.moon.fill"
            case 3: return "cloud.fill"
            case 45, 48: return "cloud.fog.fill"
            case 51, 53, 55, 56, 57: return "cloud.drizzle.fill"
            case 61, 63, 65, 66, 67: return "cloud.rain.fill"
            case 71, 73, 75, 77: return "cloud.snow.fill"
            case 80, 81, 82: return "cloud.heavyrain.fill"
            case 85, 86: return "cloud.snow.fill"
            case 95, 96, 99: return "cloud.bolt.rain.fill"
            default: return "cloud.fill"
            }
        } else {
            // Tag-Icons
            switch code {
            case 0: return "sun.max.fill"
            case 1, 2: return "cloud.sun.fill"
            case 3: return "cloud.fill"
            case 45, 48: return "cloud.fog.fill"
            case 51, 53, 55, 56, 57: return "cloud.drizzle.fill"
            case 61, 63, 65, 66, 67: return "cloud.rain.fill"
            case 71, 73, 75, 77: return "cloud.snow.fill"
            case 80, 81, 82: return "cloud.heavyrain.fill"
            case 85, 86: return "cloud.snow.fill"
            case 95, 96, 99: return "cloud.bolt.rain.fill"
            default: return "cloud.fill"
            }
        }
    }
    
    func weatherCodeToDescription(_ code: Int) -> String {
        switch code {
        case 0: return "Sonnig"
        case 1, 2: return "Teilweise bewölkt"
        case 3: return "Bewölkt"
        case 45, 48: return "Nebelig"
        case 51, 53, 55, 56, 57: return "Nieselregen"
        case 61, 63, 65: return "Regen"
        case 66, 67: return "Gefrierender Regen"
        case 71, 73, 75, 77: return "Schnee"
        case 80, 81, 82: return "Starker Regen"
        case 85, 86: return "Schneeschauer"
        case 95, 96, 99: return "Gewitter"
        default: return "Unbekannt"
        }
    }
}

// MARK: - Location Manager
@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationName: String = "Standort wird geladen..."
    var locationError: String?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestLocation() {
        // Check authorization status first
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationError = "Standortzugriff verweigert. Bitte aktivieren Sie den Zugriff in den Einstellungen."
            locationName = "Standort nicht verfügbar"
            return
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        
        // Reverse Geocoding für Standortnamen mit MapKit
        if let location = locations.first {
            Task { [weak self] in
                guard let request = MKReverseGeocodingRequest(location: location) else {
                    return
                }
                
                do {
                    let mapItems = try await request.mapItems
                    if let mapItem = mapItems.first {
                        // Use the placemark's locality or the map item's name
                        let locality = mapItem.placemark.locality ?? mapItem.name ?? "Aktueller Standort"
                        
                        await MainActor.run {
                            self?.locationName = locality
                        }
                    } else {
                        await MainActor.run {
                            self?.locationName = "Aktueller Standort"
                        }
                    }
                } catch {
                    print("Fehler beim Reverse Geocoding: \(error.localizedDescription)")
                    await MainActor.run {
                        self?.locationName = "Aktueller Standort"
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fehler beim Abrufen des Standorts: \(error.localizedDescription)")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = "Standortzugriff verweigert"
                locationName = "Standort nicht verfügbar"
            case .locationUnknown:
                locationError = "Standort konnte nicht ermittelt werden"
                locationName = "Standort unbekannt"
            default:
                locationError = error.localizedDescription
                locationName = "Standort nicht verfügbar"
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        // Automatically request location when authorized
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}

// MARK: - ContentView
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedLocation.createdAt) private var savedLocations: [SavedLocation]
    
    @State private var locationManager = LocationManager()
    @State private var currentWeather: WeatherData?
    @State private var forecast: [DayForecast] = []
    @State private var hourlyForecast: [HourlyForecast] = []
    @State private var showingAddLocation = false
    @State private var isLoading = false
    @State private var selectedLocation: SavedLocation?
    @State private var locationToDelete: SavedLocation?
    @State private var autoRefreshTimer: Timer?
    @State private var lastRefreshTime: Date?
    @State private var showingClothingRecommendation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Hintergrund - immer im Vollbild
                LinearGradient(
                    colors: [.blue.opacity(0.3), .cyan.opacity(0.2), .white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if isLoading {
                    // Lade-Ansicht im Vollbild
                    VStack {
                        Spacer()
                        ProgressView("Wetter wird geladen...")
                            .padding()
                            .tint(.primary)
                        Spacer()
                    }
                } else if let weather = currentWeather {
                    ScrollView {
                        VStack(spacing: 24) {
                            // MARK: - Aktueller Standort Header
                            VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(.secondary)
                                Text(selectedLocation?.name ?? locationManager.locationName)
                                    .font(.title2)
                                    .fontWeight(.medium)
                            }
                            
                            // Aktuelle Temperatur
                            Text("\(weather.temperature)°")
                                .font(.system(size: 80, weight: .thin))
                            
                            Text(weather.condition)
                                .font(.title3)
                                .foregroundStyle(.secondary)
                            
                            // Temperaturbereich heute
                            HStack(spacing: 16) {
                                Label("H: \(weather.highTemp)°", systemImage: "arrow.up")
                                Label("T: \(weather.lowTemp)°", systemImage: "arrow.down")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // MARK: - Stündliche Vorhersage
                        if !hourlyForecast.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Heute")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(hourlyForecast) { hour in
                                            VStack(spacing: 8) {
                                                Text(hour.time)
                                                    .font(.caption)
                                                    .fontWeight(.medium)
                                                
                                                Image(systemName: hour.icon)
                                                    .symbolRenderingMode(.multicolor)
                                                    .font(.title2)
                                                
                                                Text("\(hour.temperature)°")
                                                    .font(.body)
                                                    .fontWeight(.semibold)
                                            }
                                            .frame(width: 60)
                                            .padding(.vertical, 12)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 12) // Mehr Abstand nach unten
                        }
                        
                        // MARK: - 7-Tage-Vorhersage
                        if !forecast.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("7-Tage-Vorhersage")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 0) {
                                    ForEach(forecast) { day in
                                        HStack {
                                            Text(day.day)
                                                .frame(width: 50, alignment: .leading)
                                                .fontWeight(.medium)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                            
                                            Image(systemName: day.icon)
                                                .symbolRenderingMode(.multicolor)
                                                .frame(width: 40)
                                            
                                            Spacer()
                                            
                                            Text("\(day.lowTemp)°")
                                                .foregroundStyle(.secondary)
                                                .frame(width: 35, alignment: .trailing)
                                            
                                            // Temperatur-Balken
                                            GeometryReader { geometry in
                                                ZStack(alignment: .leading) {
                                                    Capsule()
                                                        .fill(.secondary.opacity(0.2))
                                                        .frame(height: 4)
                                                    
                                                    Capsule()
                                                        .fill(
                                                            LinearGradient(
                                                                colors: [.blue, .orange],
                                                                startPoint: .leading,
                                                                endPoint: .trailing
                                                            )
                                                        )
                                                        .frame(width: geometry.size.width * 0.7, height: 4)
                                                }
                                            }
                                            .frame(width: 80)
                                            
                                            Text("\(day.highTemp)°")
                                                .fontWeight(.medium)
                                                .frame(width: 35, alignment: .leading)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                        
                                        if day.id != forecast.last?.id {
                                            Divider()
                                                .padding(.leading, 60)
                                        }
                                    }
                                }
                                .glassEffect(.regular.tint(.blue.opacity(0.1)), in: .rect(cornerRadius: 16))
                                .padding(.horizontal)
                            }
                        }
                        
                        // MARK: - Meine Standorte (iOS 26 Liquid Glass Design)
                        if !savedLocations.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                // Header mit Add-Button
                                HStack {
                                    Text("Meine Standorte")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Button {
                                        showingAddLocation = true
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // iOS 26 List mit Liquid Glass Design & Swipe-to-Delete
                                List {
                                    ForEach(savedLocations) { location in
                                        LocationCard(
                                            location: location,
                                            onTap: {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedLocation = location
                                                    loadWeatherFor(location)
                                                }
                                            }
                                        )
                                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            // Nur für normale Standorte, NICHT für Current Location
                                            if location.isCurrentLocation == false {
                                                Button(
                                                    role: .destructive
                                                ) {
                                                    // Bestätigungsdialog anzeigen, nicht sofort löschen
                                                    locationToDelete = location
                                                } label: {
                                                    Label("Löschen", systemImage: "trash.fill")
                                                }
                                                .tint(.red)
                                            }
                                        }
                                    }
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .scrollDisabled(true)
                                .frame(height: CGFloat(savedLocations.count * 112))
                                .alert(
                                    "Standort wirklich löschen?",
                                    isPresented: Binding(
                                        get: { locationToDelete != nil },
                                        set: { if !$0 { locationToDelete = nil } }
                                    )
                                ) {
                                    Button("Löschen", role: .destructive) {
                                        if let location = locationToDelete {
                                            deleteLocation(location)
                                            locationToDelete = nil
                                        }
                                    }
                                    
                                    Button("Abbrechen", role: .cancel) {
                                        locationToDelete = nil
                                    }
                                } message: {
                                    if let location = locationToDelete {
                                        Text("\"\(location.name)\" wird aus den gespeicherten Standorten entfernt.")
                                    }
                                }
                            }
                            .padding(.top, 8)
                        } else {
                            // Empty State - Standort hinzufügen
                            VStack(spacing: 16) {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundStyle(.blue.gradient)
                                    .symbolRenderingMode(.hierarchical)
                                
                                Text("Keine Standorte gespeichert")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text("Füge deine Lieblingsorte hinzu, um\nschnell das Wetter zu überprüfen")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button {
                                    showingAddLocation = true
                                } label: {
                                    Label("Standort hinzufügen", systemImage: "plus.circle.fill")
                                        .font(.headline)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 14)
                                        .glassEffect(.regular.tint(.blue.opacity(0.2)), in: .rect(cornerRadius: 16))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        selectedLocation = nil
                        loadCurrentLocationWeather()
                    } label: {
                        Label("Aktueller Standort", systemImage: "location.circle.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showClothingRecommendation()
                    } label: {
                        Image(systemName: "tshirt.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddLocation) {
                AddLocationView(modelContext: modelContext)
            }
            .sheet(isPresented: $showingClothingRecommendation) {
                if let weather = currentWeather {
                    ClothingRecommendationView(weather: weather)
                }
            }
            .onAppear {
                if currentWeather == nil {
                    loadCurrentLocationWeather()
                }
                startAutoRefresh()
            }
            .onDisappear {
                stopAutoRefresh()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    // MARK: - Clothing Recommendation
    private func showClothingRecommendation() {
        showingClothingRecommendation = true
    }
    
    // MARK: - Auto-Refresh
    private func startAutoRefresh() {
        // Aktualisiere alle 10 Minuten (600 Sekunden)
        autoRefreshTimer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
            print("🔄 Automatische Aktualisierung...")
            refreshWeather()
        }
    }
    
    private func stopAutoRefresh() {
        autoRefreshTimer?.invalidate()
        autoRefreshTimer = nil
    }
    
    private func refreshWeather() {
        lastRefreshTime = Date()
        
        if let location = selectedLocation {
            loadWeatherFor(location)
        } else {
            loadCurrentLocationWeather()
        }
    }
    
    private func deleteLocation(_ location: SavedLocation) {
        // Falls der gelöschte Standort aktuell ausgewählt ist, zurück zum aktuellen Standort
        if selectedLocation?.id == location.id {
            selectedLocation = nil
            loadCurrentLocationWeather()
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            modelContext.delete(location)
            
            // Speichern mit Fehlerbehandlung
            do {
                try modelContext.save()
            } catch {
                print("❌ Fehler beim Löschen: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteLocations(at offsets: IndexSet) {
        for index in offsets {
            let location = savedLocations[index]
            deleteLocation(location)
        }
    }
    
    private func loadCurrentLocationWeather() {
        isLoading = true
        
        // Überprüfe Authorization Status
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Warte auf Authorization, dann lade Location
            locationManager.requestLocation()
            Task {
                // Gib dem System Zeit für Authorization Dialog und Location Update
                // Versuche mehrmals, Location zu bekommen
                var attempts = 0
                let maxAttempts = 10 // 10 Versuche = 5 Sekunden
                
                while attempts < maxAttempts {
                    try? await Task.sleep(for: .milliseconds(500))
                    
                    if let location = locationManager.currentLocation {
                        print("✅ Location gefunden nach \(attempts * 500)ms: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                        await fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        isLoading = false
                        return
                    }
                    
                    attempts += 1
                }
                
                // Nur wenn nach 5 Sekunden immer noch keine Location
                print("⚠️ Keine Location nach \(maxAttempts * 500)ms")
                print("⚠️ Authorization Status: \(locationManager.authorizationStatus.rawValue)")
                if let error = locationManager.locationError {
                    print("⚠️ Location Error: \(error)")
                }
                // Fallback zu Amman
                await fetchWeather(latitude: 31.9454, longitude: 35.9284)
                locationManager.locationName = "Amman (Standort nicht verfügbar)"
                isLoading = false
            }
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Authorization vorhanden, lade Location
            locationManager.requestLocation()
            Task {
                // Versuche mehrmals, Location zu bekommen
                var attempts = 0
                let maxAttempts = 8 // 8 Versuche = 4 Sekunden
                
                while attempts < maxAttempts {
                    try? await Task.sleep(for: .milliseconds(500))
                    
                    if let location = locationManager.currentLocation {
                        print("✅ Location gefunden nach \(attempts * 500)ms: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                        await fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        isLoading = false
                        return
                    }
                    
                    attempts += 1
                }
                
                // Nur wenn nach 4 Sekunden immer noch keine Location
                print("⚠️ Keine Location trotz Authorization nach \(maxAttempts * 500)ms")
                if let error = locationManager.locationError {
                    print("⚠️ Location Error: \(error)")
                }
                await fetchWeather(latitude: 31.9454, longitude: 35.9284)
                locationManager.locationName = "Amman (Standort nicht verfügbar)"
                isLoading = false
            }
            
        case .denied, .restricted:
            // Keine Berechtigung - sofort Fallback
            Task {
                print("❌ Location Access verweigert")
                await fetchWeather(latitude: 31.9454, longitude: 35.9284)
                locationManager.locationName = "Amman (Zugriff verweigert)"
                isLoading = false
            }
            
        @unknown default:
            Task {
                await fetchWeather(latitude: 31.9454, longitude: 35.9284)
                locationManager.locationName = "Amman"
                isLoading = false
            }
        }
    }
    
    private func loadWeatherFor(_ location: SavedLocation) {
        Task {
            isLoading = true
            await fetchWeather(latitude: location.latitude, longitude: location.longitude)
            isLoading = false
        }
    }
    
    private func fetchWeather(latitude: Double, longitude: Double) async {
        do {
            let response = try await WeatherService.shared.fetchWeather(latitude: latitude, longitude: longitude)
            
            // ISO8601 DateFormatter für Sunrise/Sunset
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Fallback: Einfacherer ISO-Parser ohne Fraktionen
            let simpleIsoFormatter = ISO8601DateFormatter()
            simpleIsoFormatter.formatOptions = [.withInternetDateTime]
            
            // Sonnenaufgang und -untergang für heute
            var sunrise: Date?
            var sunset: Date?
            
            if let sunriseString = response.daily.sunrise.first {
                sunrise = isoFormatter.date(from: sunriseString) ?? simpleIsoFormatter.date(from: sunriseString)
            }
            
            if let sunsetString = response.daily.sunset.first {
                sunset = isoFormatter.date(from: sunsetString) ?? simpleIsoFormatter.date(from: sunsetString)
            }
            
            let now = Date()
            
            // Prüfe ob es Nacht ist
            let isNightTime: Bool
            if let sunrise = sunrise, let sunset = sunset {
                isNightTime = now < sunrise || now > sunset
            } else {
                // Fallback: Zwischen 18:00 und 06:00 als Nacht betrachten
                let hour = Calendar.current.component(.hour, from: now)
                isNightTime = hour >= 18 || hour < 6
            }
            
            // Aktuelles Wetter
            let temp = Int(response.current.temperature_2m.rounded())
            let icon = WeatherService.shared.weatherCodeToIcon(response.current.weathercode, isNightTime: isNightTime)
            let condition = WeatherService.shared.weatherCodeToDescription(response.current.weathercode)
            
            // Hoch/Tief für heute
            let todayHigh = Int(response.daily.temperature_2m_max.first?.rounded() ?? 0)
            let todayLow = Int(response.daily.temperature_2m_min.first?.rounded() ?? 0)
            
            currentWeather = WeatherData(
                temperature: temp,
                condition: condition,
                icon: icon,
                highTemp: todayHigh,
                lowTemp: todayLow
            )
            
            // Stündliche Vorhersage für den Rest des Tages
            let hourlyFormatter = DateFormatter()
            hourlyFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            let calendar = Calendar.current
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) ?? now
            
            var newHourlyForecast: [HourlyForecast] = []
            
            // Erste Eintrag ist "Jetzt"
            let currentHour = HourlyForecast(
                time: "Jetzt",
                icon: icon,
                temperature: temp
            )
            newHourlyForecast.append(currentHour)
            
            // Dann alle Stunden bis Ende des Tages
            for i in 0..<response.hourly.time.count {
                let timeString = response.hourly.time[i]
                guard let hourDate = hourlyFormatter.date(from: timeString) else { continue }
                
                // Nur zukünftige Stunden und nur bis Ende des Tages
                if hourDate > now && hourDate <= endOfDay {
                    let hourTime = timeFormatter.string(from: hourDate)
                    
                    // Prüfe ob diese Stunde in der Nacht ist
                    let isHourNightTime: Bool
                    if let sunrise = sunrise, let sunset = sunset {
                        isHourNightTime = hourDate < sunrise || hourDate > sunset
                    } else {
                        let hour = calendar.component(.hour, from: hourDate)
                        isHourNightTime = hour >= 18 || hour < 6
                    }
                    
                    let hourIcon = WeatherService.shared.weatherCodeToIcon(response.hourly.weathercode[i], isNightTime: isHourNightTime)
                    let hourTemp = Int(response.hourly.temperature_2m[i].rounded())
                    
                    newHourlyForecast.append(HourlyForecast(
                        time: hourTime,
                        icon: hourIcon,
                        temperature: hourTemp
                    ))
                }
            }
            
            hourlyForecast = newHourlyForecast
            
            // 7-Tage-Vorhersage
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "de_DE")
            outputFormatter.dateFormat = "EEE"
            
            var newForecast: [DayForecast] = []
            
            for i in 0..<min(7, response.daily.time.count) {
                let dateString = response.daily.time[i]
                let date = inputFormatter.date(from: dateString) ?? Date()
                let dayName = i == 0 ? "Heute" : outputFormatter.string(from: date)
                
                // Für die 7-Tage-Vorhersage immer Tag-Icons verwenden
                let forecastIcon = WeatherService.shared.weatherCodeToIcon(response.daily.weathercode[i], isNightTime: false)
                let high = Int(response.daily.temperature_2m_max[i].rounded())
                let low = Int(response.daily.temperature_2m_min[i].rounded())
                
                newForecast.append(DayForecast(
                    day: dayName,
                    icon: forecastIcon,
                    highTemp: high,
                    lowTemp: low
                ))
            }
            
            forecast = newForecast
            
        } catch {
            print("Fehler beim Laden des Wetters: \(error)")
        }
    }
}

// MARK: - Location Card with iOS 26 Liquid Glass Design
struct LocationCard: View {
    let location: SavedLocation
    let onTap: () -> Void
    @State private var weatherData: WeatherData?
    @State private var isPressed = false
    @State private var isLoading = true
    
    var body: some View {
        HStack(spacing: 16) {
            // Links: Standortinformationen
            VStack(alignment: .leading, spacing: 6) {
                Text(location.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                if let weather = weatherData {
                    HStack(spacing: 4) {
                        Text(weather.condition)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("•")
                            .foregroundStyle(.quaternary)
                        
                        Text("H:\(weather.highTemp)° T:\(weather.lowTemp)°")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else if isLoading {
                    HStack(spacing: 6) {
                        ProgressView()
                            .scaleEffect(0.7)
                        Text("Lädt...")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                } else {
                    Text("Nicht verfügbar")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Spacer(minLength: 12)
            
            // Rechts: Wetter-Icon und Temperatur
            HStack(spacing: 12) {
                if let weather = weatherData {
                    Image(systemName: weather.icon)
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 40))
                        .frame(width: 44)
                    
                    Text("\(weather.temperature)°")
                        .font(.system(size: 44, weight: .light, design: .rounded))
                        .foregroundStyle(.primary)
                } else if isLoading {
                    // Placeholder während des Ladens
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quaternary.opacity(0.3))
                        .frame(width: 44, height: 44)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quaternary.opacity(0.3))
                        .frame(width: 60, height: 44)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(minHeight: 88)
        .glassEffect(
            .regular
                .tint(weatherTintColor)
                .interactive(),
            in: .rect(cornerRadius: 24)
        )
        // Shadow für mehr Tiefe (iOS 26 Style)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .contentShape(Rectangle()) // Wichtig: Definiert den tappable Bereich
        .onTapGesture {
            // Tap-Feedback mit Haptic
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            
            // Animation zurücksetzen und Action ausführen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
                onTap()
            }
        }
        .task {
            await loadWeather()
        }
    }
    
    // MARK: - Weather-Based Tint Colors (iOS 26 Optimiert)
    private var weatherTintColor: Color {
        guard let weather = weatherData else {
            return .blue.opacity(0.15)
        }
        
        // Dynamische Farbanpassung basierend auf Wetterbedingungen
        switch weather.icon {
        case "sun.max.fill":
            return .orange.opacity(0.25)
        case "cloud.sun.fill":
            return .yellow.opacity(0.2)
        case "cloud.fill":
            return .gray.opacity(0.25)
        case "cloud.rain.fill", "cloud.heavyrain.fill", "cloud.drizzle.fill":
            return .blue.opacity(0.3)
        case "cloud.snow.fill":
            return .cyan.opacity(0.25)
        case "cloud.bolt.rain.fill":
            return .purple.opacity(0.3)
        case "cloud.fog.fill":
            return .gray.opacity(0.2)
        default:
            return .blue.opacity(0.2)
        }
    }
    
    // MARK: - Weather Loading
    private func loadWeather() async {
        isLoading = true
        
        do {
            let response = try await WeatherService.shared.fetchWeather(
                latitude: location.latitude,
                longitude: location.longitude
            )
            
            // ISO8601 DateFormatter für Sunrise/Sunset
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            let simpleIsoFormatter = ISO8601DateFormatter()
            simpleIsoFormatter.formatOptions = [.withInternetDateTime]
            
            // Sonnenaufgang und -untergang
            var sunrise: Date?
            var sunset: Date?
            
            if let sunriseString = response.daily.sunrise.first {
                sunrise = isoFormatter.date(from: sunriseString) ?? simpleIsoFormatter.date(from: sunriseString)
            }
            
            if let sunsetString = response.daily.sunset.first {
                sunset = isoFormatter.date(from: sunsetString) ?? simpleIsoFormatter.date(from: sunsetString)
            }
            
            let now = Date()
            
            // Prüfe ob es Nacht ist
            let isNightTime: Bool
            if let sunrise = sunrise, let sunset = sunset {
                isNightTime = now < sunrise || now > sunset
            } else {
                let hour = Calendar.current.component(.hour, from: now)
                isNightTime = hour >= 18 || hour < 6
            }
            
            let temp = Int(response.current.temperature_2m.rounded())
            let icon = WeatherService.shared.weatherCodeToIcon(response.current.weathercode, isNightTime: isNightTime)
            let condition = WeatherService.shared.weatherCodeToDescription(response.current.weathercode)
            let todayHigh = Int(response.daily.temperature_2m_max.first?.rounded() ?? 0)
            let todayLow = Int(response.daily.temperature_2m_min.first?.rounded() ?? 0)
            
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    weatherData = WeatherData(
                        temperature: temp,
                        condition: condition,
                        icon: icon,
                        highTemp: todayHigh,
                        lowTemp: todayLow
                    )
                    isLoading = false
                }
            }
        } catch {
            print("Fehler beim Laden des Wetters für \(location.name): \(error)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

// MARK: - Add Location View
struct AddLocationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    let modelContext: ModelContext
    
    // Vordefinierte beliebte Städte weltweit
    let popularCities: [(String, Double, Double, String)] = [
        // Deutschland
        ("Berlin", 52.52, 13.405, "Deutschland"),
        ("München", 48.1351, 11.5820, "Deutschland"),
        ("Hamburg", 53.5511, 9.9937, "Deutschland"),
        ("Köln", 50.9375, 6.9603, "Deutschland"),
        ("Frankfurt", 50.1109, 8.6821, "Deutschland"),
        ("Stuttgart", 48.7758, 9.1829, "Deutschland"),
        ("Düsseldorf", 51.2277, 6.7735, "Deutschland"),
        ("Dortmund", 51.5136, 7.4653, "Deutschland"),
        ("Leipzig", 51.3397, 12.3731, "Deutschland"),
        ("Dresden", 51.0504, 13.7373, "Deutschland"),
        
        // Europa
        ("London", 51.5074, -0.1278, "Vereinigtes Königreich"),
        ("Paris", 48.8566, 2.3522, "Frankreich"),
        ("Rom", 41.9028, 12.4964, "Italien"),
        ("Madrid", 40.4168, -3.7038, "Spanien"),
        ("Barcelona", 41.3874, 2.1686, "Spanien"),
        ("Amsterdam", 52.3676, 4.9041, "Niederlande"),
        ("Wien", 48.2082, 16.3738, "Österreich"),
        ("Zürich", 47.3769, 8.5417, "Schweiz"),
        ("Prag", 50.0755, 14.4378, "Tschechien"),
        ("Warschau", 52.2297, 21.0122, "Polen"),
        ("Kopenhagen", 55.6761, 12.5683, "Dänemark"),
        ("Stockholm", 59.3293, 18.0686, "Schweden"),
        ("Oslo", 59.9139, 10.7522, "Norwegen"),
        ("Helsinki", 60.1699, 24.9384, "Finnland"),
        ("Brüssel", 50.8503, 4.3517, "Belgien"),
        ("Dublin", 53.3498, -6.2603, "Irland"),
        ("Lissabon", 38.7223, -9.1393, "Portugal"),
        ("Athen", 37.9838, 23.7275, "Griechenland"),
        
        // Naher Osten
        ("Dubai", 25.2048, 55.2708, "VAE"),
        ("Abu Dhabi", 24.4539, 54.3773, "VAE"),
        ("Doha", 25.2854, 51.5310, "Katar"),
        ("Riad", 24.7136, 46.6753, "Saudi-Arabien"),
        ("Jeddah", 21.5433, 39.1728, "Saudi-Arabien"),
        ("Tel Aviv", 32.0853, 34.7818, "Israel"),
        ("Jerusalem", 31.7683, 35.2137, "Israel"),
        ("Beirut", 33.8886, 35.4955, "Libanon"),
        ("Amman", 31.9454, 35.9284, "Jordanien"),
        ("Kuwait", 29.3759, 47.9774, "Kuwait"),
        ("Damaskus", 33.5138, 36.2765, "Syrien"),
        ("Bagdad", 33.3152, 44.3661, "Irak"),
        ("Kairo", 30.0444, 31.2357, "Ägypten"),
        ("Istanbul", 41.0082, 28.9784, "Türkei"),
        ("Ankara", 39.9334, 32.8597, "Türkei"),
        
        // Asien
        ("Tokyo", 35.6762, 139.6503, "Japan"),
        ("Peking", 39.9042, 116.4074, "China"),
        ("Shanghai", 31.2304, 121.4737, "China"),
        ("Hongkong", 22.3193, 114.1694, "Hongkong"),
        ("Singapur", 1.3521, 103.8198, "Singapur"),
        ("Seoul", 37.5665, 126.9780, "Südkorea"),
        ("Bangkok", 13.7563, 100.5018, "Thailand"),
        ("Mumbai", 19.0760, 72.8777, "Indien"),
        ("Delhi", 28.6139, 77.2090, "Indien"),
        ("Manila", 14.5995, 120.9842, "Philippinen"),
        
        // Amerika
        ("New York", 40.7128, -74.0060, "USA"),
        ("Los Angeles", 34.0522, -118.2437, "USA"),
        ("Chicago", 41.8781, -87.6298, "USA"),
        ("Miami", 25.7617, -80.1918, "USA"),
        ("San Francisco", 37.7749, -122.4194, "USA"),
        ("Washington", 38.9072, -77.0369, "USA"),
        ("Toronto", 43.6532, -79.3832, "Kanada"),
        ("Mexiko-Stadt", 19.4326, -99.1332, "Mexiko"),
        ("Buenos Aires", -34.6037, -58.3816, "Argentinien"),
        ("São Paulo", -23.5505, -46.6333, "Brasilien"),
        ("Rio de Janeiro", -22.9068, -43.1729, "Brasilien"),
        
        // Ozeanien
        ("Sydney", -33.8688, 151.2093, "Australien"),
        ("Melbourne", -37.8136, 144.9631, "Australien"),
        ("Auckland", -36.8485, 174.7633, "Neuseeland"),
        
        // Afrika
        ("Kapstadt", -33.9249, 18.4241, "Südafrika"),
        ("Johannesburg", -26.2041, 28.0473, "Südafrika"),
        ("Lagos", 6.5244, 3.3792, "Nigeria"),
        ("Nairobi", -1.2864, 36.8172, "Kenia"),
        ("Casablanca", 33.5731, -7.5898, "Marokko")
    ]
    
    var filteredCities: [(String, Double, Double, String)] {
        if searchText.isEmpty {
            return popularCities
        } else {
            return popularCities.filter { city in
                city.0.localizedCaseInsensitiveContains(searchText) ||
                city.3.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Beliebte/Gefilterte Städte - IMMER anzeigen
                Section(header: Text(searchText.isEmpty ? "Beliebte Städte" : "Städte")) {
                    ForEach(filteredCities, id: \.0) { city in
                        Button {
                            addLocation(name: city.0, latitude: city.1, longitude: city.2)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(city.0)
                                        .foregroundStyle(.primary)
                                    Text(city.3)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "location.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    
                    if !searchText.isEmpty && filteredCities.isEmpty {
                        Text("Keine passenden Städte gefunden")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Stadt oder Ort suchen")
            .navigationTitle("Standort hinzufügen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
            .onChange(of: searchText) { oldValue, newValue in
                // Suche wurde entfernt - wir nutzen nur noch die vordefinierte Liste
                // Die wird automatisch durch filteredCities gefiltert
            }
        }
    }
    
    private func addLocation(name: String, latitude: Double, longitude: Double) {
        let newLocation = SavedLocation(
            name: name,
            latitude: latitude,
            longitude: longitude,
            isCurrentLocation: false
        )
        
        modelContext.insert(newLocation)
        
        do {
            try modelContext.save()
        } catch {
            print("Fehler beim Speichern: \(error)")
        }
        
        dismiss()
    }
}

// MARK: - Geocoding Service
struct GeocodingResult: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let displayName: String
}

// Internes Codable Modell für die API-Antwort
private struct NominatimResult: Codable {
    let lat: String
    let lon: String
    let displayName: String
    let name: String?
    let address: Address?
    
    struct Address: Codable {
        let city: String?
        let town: String?
        let village: String?
        let country: String?
        let state: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, name, address
        case displayName = "display_name"
    }
}

class GeocodingService {
    static let shared = GeocodingService()
    private var lastRequestTime: Date?
    
    private init() {}
    
    func searchLocations(query: String) async -> [GeocodingResult] {
        guard !query.isEmpty else { return [] }
        
        // Rate Limiting: Warte mindestens 2 Sekunden zwischen Anfragen
        if let lastTime = lastRequestTime {
            let timeSinceLastRequest = Date().timeIntervalSince(lastTime)
            if timeSinceLastRequest < 2.0 {
                let waitTime = 2.0 - timeSinceLastRequest
                try? await Task.sleep(for: .milliseconds(Int(waitTime * 1000)))
            }
        }
        lastRequestTime = Date()
        
        // URL-encode the query
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        
        // Nominatim API (OpenStreetMap)
        let urlString = "https://nominatim.openstreetmap.org/search?q=\(encodedQuery)&format=json&limit=10&addressdetails=1"
        
        guard let url = URL(string: urlString) else {
            return []
        }
        
        var request = URLRequest(url: url)
        // Wichtig: Besserer User-Agent mit Kontaktinformationen
        request.setValue("WeatherApp/1.0 (iOS)", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 15
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Überprüfe HTTP Status
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 418 {
                    print("⚠️ Rate Limit: Zu viele Anfragen (418). Bitte warten...")
                    // Warte länger beim nächsten Mal
                    try? await Task.sleep(for: .seconds(3))
                    return []
                }
                
                if httpResponse.statusCode == 429 {
                    print("⚠️ Rate Limit erreicht (429)")
                    return []
                }
                
                if httpResponse.statusCode != 200 {
                    print("⚠️ Unerwarteter Status Code: \(httpResponse.statusCode)")
                    return []
                }
            }
            
            // Debug: Zeige die Datengröße
            print("📦 Empfangene Daten: \(data.count) Bytes")
            
            // Überprüfe ob Daten leer sind
            if data.isEmpty {
                print("⚠️ Leere Antwort erhalten")
                return []
            }
            
            // Debug: Zeige die rohe Antwort
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📡 API Response: \(jsonString.prefix(300))...")
            }
            
            // Versuche zu decodieren
            let nominatimResults = try JSONDecoder().decode([NominatimResult].self, from: data)
            
            print("✅ Decodiert: \(nominatimResults.count) Ergebnisse")
            
            // Konvertiere zu GeocodingResult
            return nominatimResults.compactMap { result in
                guard let lat = Double(result.lat),
                      let lon = Double(result.lon) else {
                    return nil
                }
                
                // Versuche einen sinnvollen Namen zu extrahieren
                let name = result.name
                    ?? result.address?.city
                    ?? result.address?.town
                    ?? result.address?.village
                    ?? result.displayName.components(separatedBy: ",").first
                    ?? "Unbekannt"
                
                let country = result.address?.country ?? ""
                
                return GeocodingResult(
                    name: name,
                    latitude: lat,
                    longitude: lon,
                    country: country,
                    displayName: result.displayName
                )
            }
        } catch let decodingError as DecodingError {
            print("❌ JSON Decodierung fehlgeschlagen: \(decodingError)")
            return []
        } catch let error as URLError where error.code == .cancelled {
            // Cancelled-Fehler ignorieren (passiert beim Debouncing)
            print("⏭️ Suche abgebrochen (Debouncing)")
            return []
        } catch {
            print("❌ Geocoding-Fehler: \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - Clothing Recommendation View
struct ClothingRecommendationView: View {
    let weather: WeatherData
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: ClothingItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamischer Hintergrund basierend auf Temperatur
                LinearGradient(
                    colors: temperatureFeeling.gradientColors + [.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // MARK: - Temperatur & Wetter Header
                        VStack(spacing: 12) {
                            // Große Temperatur
                            Text("\(weather.temperature)°")
                                .font(.system(size: 96, weight: .thin, design: .rounded))
                                .foregroundStyle(.primary)
                            
                            // Gefühlte Temperatur & Wetter
                            VStack(spacing: 4) {
                                Text(weather.condition)
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: weather.icon)
                                        .symbolRenderingMode(.multicolor)
                                        .font(.title2)
                                    
                                    Text("H: \(weather.highTemp)° · T: \(weather.lowTemp)°")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.top, 20)
                        
                        // MARK: - Temperatur-Badge
                        Text(temperatureFeeling.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(temperatureFeeling.color.gradient)
                            )
                        
                        // MARK: - Outfit-Empfehlung (Key Feature)
                        VStack(spacing: 20) {
                            Text("Was ziehe ich jetzt an?")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            // Kleidungs-Icons Grid
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(clothingItems) { item in
                                    ClothingIconButton(item: item) {
                                        selectedItem = item
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationTitle("Outfit-Empfehlung")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedItem) { item in
                ClothingDetailSheet(item: item, weather: weather)
                    .presentationDetents([.height(280)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - Temperature Feeling Logic
    private var temperatureFeeling: TemperatureFeeling {
        switch weather.temperature {
        case ..<0:
            return .veryCold
        case 0..<9:
            return .cold
        case 9..<16:
            return .cool
        case 16..<23:
            return .mild
        case 23..<30:
            return .warm
        case 30..<35:
            return .hot
        default:
            return .veryHot
        }
    }
    
    // MARK: - Clothing Items Logic
    private var clothingItems: [ClothingItem] {
        var items: [ClothingItem] = []
        let temp = weather.temperature
        let condition = weather.condition.lowercased()
        
        // Basis-Kleidung nach Temperatur
        switch temp {
        case ..<0: // Unter 0° - Sehr kalt
            items.append(ClothingItem(
                icon: "🧥",
                name: "Dicke Winterjacke",
                reason: "Bei \(temp)° schützt eine dicke Winterjacke vor der Kälte",
                color: .blue
            ))
            items.append(ClothingItem(
                icon: "🧣",
                name: "Schal",
                reason: "Hält den Hals warm bei eisigen Temperaturen",
                color: .cyan
            ))
            items.append(ClothingItem(
                icon: "🧤",
                name: "Handschuhe",
                reason: "Schützen die Hände vor Erfrierungen",
                color: .blue
            ))
            items.append(ClothingItem(
                icon: "👢",
                name: "Winterstiefel",
                reason: "Warme Füße bei Minusgraden",
                color: .brown
            ))
            
        case 0..<9: // 0° - 8° - Kalt
            items.append(ClothingItem(
                icon: "🧥",
                name: "Warme Jacke",
                reason: "Bei \(temp)° brauchst du eine warme Jacke",
                color: .blue
            ))
            items.append(ClothingItem(
                icon: "👕",
                name: "Pullover",
                reason: "Hält dich warm bei kühlen Temperaturen",
                color: .indigo
            ))
            items.append(ClothingItem(
                icon: "👖",
                name: "Lange Hose",
                reason: "Schützt vor Kälte",
                color: .blue
            ))
            
        case 9..<16: // 9° - 15° - Kühl
            items.append(ClothingItem(
                icon: "🧥",
                name: "Übergangsjacke",
                reason: "Bei \(temp)° ideal für den Übergang",
                color: .cyan
            ))
            items.append(ClothingItem(
                icon: "👕",
                name: "Langarmshirt",
                reason: "Angenehm bei milden Temperaturen",
                color: .green
            ))
            items.append(ClothingItem(
                icon: "👖",
                name: "Jeans",
                reason: "Perfekt für das Übergangswetter",
                color: .blue
            ))
            
        case 16..<23: // 16° - 22° - Mild
            items.append(ClothingItem(
                icon: "👕",
                name: "T-Shirt",
                reason: "Bei \(temp)° ist ein T-Shirt perfekt",
                color: .green
            ))
            items.append(ClothingItem(
                icon: "🧥",
                name: "Leichte Jacke",
                reason: "Optional für abends oder schattige Bereiche",
                color: .mint
            ))
            items.append(ClothingItem(
                icon: "👖",
                name: "Leichte Hose",
                reason: "Bequem bei angenehmen Temperaturen",
                color: .green
            ))
            
        case 23..<30: // 23° - 29° - Warm
            items.append(ClothingItem(
                icon: "👕",
                name: "T-Shirt",
                reason: "Bei \(temp)° reicht ein luftiges T-Shirt",
                color: .orange
            ))
            items.append(ClothingItem(
                icon: "🩳",
                name: "Shorts",
                reason: "Angenehm bei warmen Temperaturen",
                color: .yellow
            ))
            items.append(ClothingItem(
                icon: "🕶️",
                name: "Sonnenbrille",
                reason: "Schützt die Augen vor UV-Strahlung",
                color: .orange
            ))
            
        default: // 30°+ - Sehr heiß
            items.append(ClothingItem(
                icon: "👕",
                name: "Tank Top",
                reason: "Bei \(temp)° so luftig wie möglich",
                color: .red
            ))
            items.append(ClothingItem(
                icon: "🩳",
                name: "Shorts",
                reason: "Unverzichtbar bei Hitze",
                color: .orange
            ))
            items.append(ClothingItem(
                icon: "🧢",
                name: "Cap",
                reason: "Schützt den Kopf vor der Sonne",
                color: .red
            ))
            items.append(ClothingItem(
                icon: "🧴",
                name: "Sonnencreme",
                reason: "Wichtig bei starker UV-Strahlung",
                color: .orange
            ))
        }
        
        // Wetter-Modifier (überschreibt/ergänzt Basis-Items)
        if condition.contains("regen") || condition.contains("niesel") {
            // Regenjacke hinzufügen wenn noch nicht zu heiß
            if temp < 25 {
                items.append(ClothingItem(
                    icon: "☔️",
                    name: "Regenjacke",
                    reason: "Es regnet - bleib trocken!",
                    color: .blue
                ))
            } else {
                items.append(ClothingItem(
                    icon: "☔️",
                    name: "Regenschirm",
                    reason: "Regenschutz bei warmen Temperaturen",
                    color: .blue
                ))
            }
        }
        
        if condition.contains("schnee") {
            items.append(ClothingItem(
                icon: "👢",
                name: "Winterstiefel",
                reason: "Schnee - wasserdichte Schuhe sind wichtig",
                color: .brown
            ))
            if !items.contains(where: { $0.icon == "🧤" }) {
                items.append(ClothingItem(
                    icon: "🧤",
                    name: "Handschuhe",
                    reason: "Hält die Hände warm im Schnee",
                    color: .blue
                ))
            }
        }
        
        if condition.contains("wind") || condition.contains("sturm") {
            if temp < 20 && !items.contains(where: { $0.name.contains("jacke") || $0.name.contains("Jacke") }) {
                items.append(ClothingItem(
                    icon: "🧥",
                    name: "Windbreaker",
                    reason: "Wind - eine winddichte Jacke schützt",
                    color: .teal
                ))
            }
        }
        
        if condition.contains("sonnig") || condition.contains("klar") {
            if temp > 20 && !items.contains(where: { $0.icon == "🕶️" }) {
                items.append(ClothingItem(
                    icon: "🕶️",
                    name: "Sonnenbrille",
                    reason: "Sonniges Wetter - schütze deine Augen",
                    color: .yellow
                ))
            }
        }
        
        // Maximal 4 Items anzeigen (UX-Prinzip: nicht überladen)
        return Array(items.prefix(4))
    }
}

// MARK: - Clothing Icon Button
struct ClothingIconButton: View {
    let item: ClothingItem
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Haptic Feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: 12) {
                // Icon
                Text(item.icon)
                    .font(.system(size: 64))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // Name
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(.vertical, 16)
            .glassEffect(
                .regular
                    .tint(item.color.opacity(0.15))
                    .interactive(),
                in: .rect(cornerRadius: 20)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Clothing Detail Sheet
struct ClothingDetailSheet: View {
    let item: ClothingItem
    let weather: WeatherData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Handle Indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(.quaternary)
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            // Icon groß
            Text(item.icon)
                .font(.system(size: 80))
            
            // Name
            Text(item.name)
                .font(.title2)
                .fontWeight(.bold)
            
            // Warum? - Erklärung
            VStack(spacing: 12) {
                Text("Warum?")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text(item.reason)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [item.color.opacity(0.1), .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .modelContainer(for: SavedLocation.self, inMemory: true)
}
