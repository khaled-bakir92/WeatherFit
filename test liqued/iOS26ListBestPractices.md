//
//  iOS26ListBestPractices.md
//  SwiftUI Liste mit Swipe-to-Delete im iOS 26 Liquid Glass Design
//

# iOS 26 Liste mit Swipe-to-Delete – Best Practices

## 📋 Übersicht

Diese Implementierung zeigt eine moderne SwiftUI-Liste im iOS 26 Liquid Glass Design mit folgenden Features:

✅ Native Swipe-to-Delete Gesten
✅ Liquid Glass Material-Effekte
✅ Interaktive Animationen
✅ Dark Mode optimiert
✅ SwiftData Integration
✅ Performance-optimiert

---

## 🎨 Design-Prinzipien (iOS 26)

### 1. Liquid Glass Effekte
```swift
.glassEffect(
    .regular
        .tint(Color.blue.opacity(0.2))  // Subtile Färbung
        .interactive(),                  // Touch-responsive
    in: .rect(cornerRadius: 20)         // Abgerundete Ecken
)
```

### 2. Spacing & Padding
- **List Row Insets**: `EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)`
- **Card Padding**: `.padding(.horizontal, 18)` + `.padding(.vertical, 16)`
- **Minimum Height**: `88-104px` für optimale Touch-Targets

### 3. Schatten & Tiefe
```swift
.shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
```

---

## 🔧 Swipe-to-Delete Implementation

### Standard Implementation
```swift
.swipeActions(edge: .trailing, allowsFullSwipe: false) {
    Button(
        "Löschen",
        systemImage: "trash.fill",
        role: .destructive
    ) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            deleteItem(item)
        }
    }
    .labelStyle(.iconOnly)
    .tint(.red)
}
```

### Wichtige Parameter:

1. **edge: .trailing** 
   - Button erscheint rechts beim Swipe von rechts nach links

2. **allowsFullSwipe: false**
   - Verhindert versehentliches Löschen durch vollständigen Swipe
   - User muss explizit auf Delete-Button tippen

3. **role: .destructive**
   - Macht Button automatisch rot
   - Semantisch korrekt für Delete-Aktionen

4. **labelStyle(.iconOnly)**
   - Zeigt nur das Icon, keinen Text
   - Spart Platz, modernes Design

5. **systemImage: "trash.fill"**
   - SF Symbol für Delete
   - Gefüllt für bessere Sichtbarkeit

---

## 🎯 List Configuration

### iOS 26 Optimierte List
```swift
List {
    ForEach(items) { item in
        ItemCard(item: item)
            .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                // Delete Action
            }
    }
}
.listStyle(.plain)
.scrollContentBackground(.hidden)
```

### Erklärung:

- **listRowInsets**: Mehr Padding für moderne Optik
- **listRowBackground(.clear)**: Transparenter Hintergrund für Gradient
- **listRowSeparator(.hidden)**: Keine Trennlinien zwischen Items
- **listStyle(.plain)**: Einfacher Stil ohne Gruppierung
- **scrollContentBackground(.hidden)**: Hintergrund-Gradient bleibt sichtbar

---

## 🎬 Animationen

### 1. Button Press Animation
```swift
@State private var isPressed = false

.scaleEffect(isPressed ? 0.97 : 1.0)
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
.simultaneousGesture(
    DragGesture(minimumDistance: 0)
        .onChanged { _ in isPressed = true }
        .onEnded { _ in isPressed = false }
)
```

### 2. Delete Animation
```swift
withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
    deleteItem(item)
}
```

### Spring-Parameter:
- **response**: 0.3 = schnell und responsiv
- **dampingFraction**: 0.7-0.8 = leichtes Bounce-Gefühl

---

## 🗂️ State Management

### SwiftData Integration
```swift
@Environment(\.modelContext) private var modelContext
@Query(sort: \SavedLocation.createdAt) private var items: [SavedLocation]

private func deleteItem(_ item: SavedLocation) {
    modelContext.delete(item)
    
    do {
        try modelContext.save()
    } catch {
        print("Fehler beim Löschen: \(error)")
    }
}
```

### Best Practices:
1. Verwende `@Query` für automatische Updates
2. Animiere das Löschen mit `withAnimation`
3. Behandle Fehler beim Speichern
4. Keine manuelle Array-Manipulation nötig

---

## 🎨 Liquid Glass Farbschemata

### Kontext-basierte Farben
```swift
private var tintColor: Color {
    switch condition {
    case .sunny:
        return .orange.opacity(0.25)
    case .cloudy:
        return .gray.opacity(0.25)
    case .rainy:
        return .blue.opacity(0.3)
    case .snowy:
        return .cyan.opacity(0.25)
    default:
        return .blue.opacity(0.2)
    }
}
```

### Opacity-Richtlinien:
- **Sehr hell**: 0.1-0.15 (subtil)
- **Standard**: 0.2-0.25 (ausgeglichen)
- **Intensiv**: 0.3-0.4 (auffällig)

---

## 📱 Responsive Design

### Dynamische List Height
```swift
.frame(height: CGFloat(items.count * 104))
.scrollDisabled(items.count <= 4)
```

### Adaptive Content
```swift
.lineLimit(1)
.minimumScaleFactor(0.8)
```

---

## ⚡ Performance-Optimierungen

### 1. Lazy Loading
```swift
.task {
    await loadData()
}
```

### 2. MainActor für UI-Updates
```swift
await MainActor.run {
    withAnimation {
        self.data = newData
    }
}
```

### 3. Debouncing bei Searches
```swift
.onChange(of: searchText) { oldValue, newValue in
    Task {
        try? await Task.sleep(for: .milliseconds(300))
        await performSearch(newValue)
    }
}
```

---

## 🌙 Dark Mode Support

### Automatisch durch System Colors
```swift
.foregroundStyle(.primary)    // Schwarz/Weiß
.foregroundStyle(.secondary)  // Grau
.foregroundStyle(.tertiary)   // Heller Grau
.foregroundStyle(.quaternary) // Sehr heller Grau
```

### Liquid Glass passt sich automatisch an
```swift
.glassEffect(.regular.tint(.blue.opacity(0.2)))
// Funktioniert perfekt in Light & Dark Mode
```

---

## 🧪 Testing

### Preview mit Sample Data
```swift
#Preview {
    iOS26ListView()
        .modelContainer(for: Item.self, inMemory: true)
}
```

### Preview mit vorhandenen Daten
```swift
#Preview("Mit Daten") {
    let container = try! ModelContainer(for: Item.self, inMemory: true)
    
    // Sample Daten einfügen
    let item1 = Item(title: "Test 1")
    let item2 = Item(title: "Test 2")
    container.mainContext.insert(item1)
    container.mainContext.insert(item2)
    
    return iOS26ListView()
        .modelContainer(container)
}
```

---

## 🎯 Checklist für iOS 26 Listen

- [ ] `.swipeActions` statt `.onDelete` verwendet
- [ ] `allowsFullSwipe: false` gesetzt
- [ ] `.labelStyle(.iconOnly)` für Delete-Button
- [ ] `systemImage: "trash.fill"` verwendet
- [ ] `role: .destructive` gesetzt
- [ ] `.glassEffect` mit `.interactive()` verwendet
- [ ] Animationen mit Spring-Effekt
- [ ] `listRowSeparator(.hidden)` gesetzt
- [ ] `listRowBackground(.clear)` gesetzt
- [ ] Spacing mindestens 8pt zwischen Items
- [ ] Corner Radius 20-24pt
- [ ] Schatten mit opacity 0.04-0.05
- [ ] Dark Mode getestet

---

## 📦 Vollständiges Minimal-Beispiel

```swift
import SwiftUI
import SwiftData

@Model
final class Item {
    var id: UUID
    var title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

struct MinimalListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.title)
                    .padding()
                    .glassEffect(.regular.tint(.blue.opacity(0.2)), in: .rect(cornerRadius: 20))
                    .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Löschen", systemImage: "trash.fill", role: .destructive) {
                            withAnimation {
                                modelContext.delete(item)
                            }
                        }
                        .labelStyle(.iconOnly)
                        .tint(.red)
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
```

---

## 🚀 Erweiterte Features

### Mehrere Swipe Actions
```swift
.swipeActions(edge: .trailing, allowsFullSwipe: false) {
    Button("Löschen", systemImage: "trash.fill", role: .destructive) {
        delete()
    }
    .labelStyle(.iconOnly)
}
.swipeActions(edge: .leading, allowsFullSwipe: false) {
    Button("Favorit", systemImage: "star.fill") {
        toggleFavorite()
    }
    .labelStyle(.iconOnly)
    .tint(.yellow)
}
```

### Konditionales Swipe
```swift
if item.isDeletable {
    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
        // Delete Action
    }
}
```

---

## 🎓 Zusammenfassung

Diese Implementation kombiniert:

1. **Moderne SwiftUI-Patterns** (iOS 26)
2. **Liquid Glass Design System**
3. **Native Swipe Gestures**
4. **Performance Best Practices**
5. **Accessibility Support**
6. **Dark Mode Optimization**

Das Ergebnis ist eine Liste, die sich genau wie eine native Apple-App anfühlt und vollständig den iOS 26 Design-Richtlinien entspricht.

---

**Erstellt**: Januar 2026
**SwiftUI Version**: iOS 26.0+
**Swift Version**: 6.0+
