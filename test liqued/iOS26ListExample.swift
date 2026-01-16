//
//  iOS26ListExample.swift
//  iOS 26 Liquid Glass List Implementation
//
//  Vollständiges Beispiel für moderne SwiftUI-Listen mit Swipe-to-Delete
//

import SwiftUI
import SwiftData

// MARK: - Datenmodell
@Model
final class ListItem {
    var id: UUID
    var title: String
    var subtitle: String
    var iconName: String
    var accentColor: String
    var createdAt: Date
    
    init(title: String, subtitle: String, iconName: String = "star.fill", accentColor: String = "blue") {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.accentColor = accentColor
        self.createdAt = Date()
    }
}

// MARK: - Hauptansicht mit iOS 26 Design
struct iOS26ListExampleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ListItem.createdAt, order: .reverse) private var items: [ListItem]
    
    @State private var showingAddSheet = false
    @State private var selectedItem: ListItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Hintergrund-Gradient (iOS 26 Style)
                LinearGradient(
                    colors: [
                        .blue.opacity(0.1),
                        .purple.opacity(0.05),
                        .white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if items.isEmpty {
                    // Empty State
                    emptyStateView
                } else {
                    // Liste mit iOS 26 Liquid Glass Design
                    ScrollView {
                        VStack(spacing: 0) {
                            // Header
                            headerView
                                .padding(.top, 20)
                                .padding(.bottom, 12)
                            
                            // iOS 26 List
                            liquidGlassList
                        }
                    }
                }
            }
            .navigationTitle("iOS 26 Liste")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddItemSheet(modelContext: modelContext)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Meine Einträge")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(items.count) \(items.count == 1 ? "Eintrag" : "Einträge")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Liquid Glass List (iOS 26)
    private var liquidGlassList: some View {
        List {
            ForEach(items) { item in
                iOS26ListItemCard(
                    item: item,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedItem = item
                        }
                    }
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    // Delete Action (iOS 26 Style)
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
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    // Optionale zusätzliche Actions
                    Button(
                        "Favorit",
                        systemImage: "star.fill"
                    ) {
                        // Favoriten-Logik
                    }
                    .labelStyle(.iconOnly)
                    .tint(.yellow)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollDisabled(items.count <= 4) // Bei wenigen Items kein Scrolling nötig
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.blue.gradient)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 8) {
                Text("Keine Einträge")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Füge deinen ersten Eintrag hinzu,\num loszulegen")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                showingAddSheet = true
            } label: {
                Label("Eintrag hinzufügen", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.tint(.blue.opacity(0.2)), in: .rect(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
        .padding(40)
    }
    
    // MARK: - Delete Helper
    private func deleteItem(_ item: ListItem) {
        modelContext.delete(item)
        
        do {
            try modelContext.save()
        } catch {
            print("Fehler beim Löschen: \(error)")
        }
    }
}

// MARK: - iOS 26 List Item Card
struct iOS26ListItemCard: View {
    let item: ListItem
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon Container mit Liquid Glass Effect
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accentColor.gradient.opacity(0.2))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: item.iconName)
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                        .foregroundStyle(accentColor)
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer(minLength: 8)
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .frame(minHeight: 88)
            .glassEffect(
                .regular
                    .tint(accentColor.opacity(0.08))
                    .interactive(),
                in: .rect(cornerRadius: 20)
            )
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
    
    private var accentColor: Color {
        switch item.accentColor {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        default: return .blue
        }
    }
}

// MARK: - Add Item Sheet
struct AddItemSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = "blue"
    
    let modelContext: ModelContext
    
    private let icons = [
        "star.fill", "heart.fill", "bookmark.fill", "flag.fill",
        "location.fill", "folder.fill", "doc.fill", "tag.fill",
        "bell.fill", "calendar.fill", "cart.fill", "bag.fill"
    ]
    
    private let colors = [
        ("red", Color.red),
        ("orange", Color.orange),
        ("yellow", Color.yellow),
        ("green", Color.green),
        ("blue", Color.blue),
        ("purple", Color.purple),
        ("pink", Color.pink)
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Titel", text: $title)
                    TextField("Untertitel", text: $subtitle)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                        ForEach(icons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Farbe") {
                    HStack(spacing: 16) {
                        ForEach(colors, id: \.0) { colorName, color in
                            Button {
                                selectedColor = colorName
                            } label: {
                                Circle()
                                    .fill(color.gradient)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(.white, lineWidth: selectedColor == colorName ? 3 : 0)
                                    )
                                    .shadow(color: .black.opacity(0.1), radius: 4)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Neuer Eintrag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Hinzufügen") {
                        addItem()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = ListItem(
            title: title,
            subtitle: subtitle.isEmpty ? "Kein Untertitel" : subtitle,
            iconName: selectedIcon,
            accentColor: selectedColor
        )
        
        modelContext.insert(newItem)
        
        do {
            try modelContext.save()
        } catch {
            print("Fehler beim Speichern: \(error)")
        }
        
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    iOS26ListExampleView()
        .modelContainer(for: ListItem.self, inMemory: true)
}
