import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var appSettings: [AppSettings]
    
    @State private var selectedLanguage: AppLanguage = .english
    @State private var selectedTheme: AppTheme = .system
    @State private var selectedCalendar: CalendarType = .gregorian
    @State private var selectedPrimaryColor: String = "blue"
    @State private var selectedAccentColor: String = "orange"
    
    var body: some View {
        NavigationView {
            Form {
                // Language Settings
                Section(header: Text(localizationManager.localizedString(.language))) {
                    Picker(localizationManager.localizedString(.language), selection: $selectedLanguage) {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            Text(language.displayName)
                                .tag(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedLanguage) { _, newValue in
                        localizationManager.setLanguage(newValue)
                        saveSettings()
                    }
                }
                
                // Theme Settings
                Section(header: Text(localizationManager.localizedString(.theme))) {
                    Picker(localizationManager.localizedString(.theme), selection: $selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            HStack {
                                Image(systemName: themeIcon(for: theme))
                                Text(themeText(for: theme))
                            }
                            .tag(theme)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedTheme) { _, newValue in
                        themeManager.setTheme(newValue)
                        saveSettings()
                    }
                }
                
                // Calendar Settings
                Section(header: Text(localizationManager.localizedString(.calendar))) {
                    Picker(localizationManager.localizedString(.calendar), selection: $selectedCalendar) {
                        ForEach(CalendarType.allCases, id: \.self) { calendar in
                            Text(calendarText(for: calendar))
                                .tag(calendar)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedCalendar) { _, newValue in
                        saveSettings()
                    }
                }
                
                // Color Settings
                Section(header: Text(localizationManager.localizedString(.colors))) {
                    // Primary Color
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.localizedString(.primaryColor))
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(ThemeManager.availableColors, id: \.self) { color in
                                Button(action: {
                                    selectedPrimaryColor = color
                                    themeManager.setPrimaryColor(color)
                                    saveSettings()
                                }) {
                                    Circle()
                                        .fill(colorValue(for: color))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedPrimaryColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                        )
                                }
                            }
                        }
                    }
                    
                    // Accent Color
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.localizedString(.accentColor))
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(ThemeManager.availableColors, id: \.self) { color in
                                Button(action: {
                                    selectedAccentColor = color
                                    themeManager.setAccentColor(color)
                                    saveSettings()
                                }) {
                                    Circle()
                                        .fill(colorValue(for: color))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedAccentColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                        )
                                }
                            }
                        }
                    }
                }
                
                // App Information
                Section(header: Text(localizationManager.localizedString(.about))) {
                    HStack {
                        Text(localizationManager.localizedString(.version))
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink(destination: Text("Help content will be here")) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text(localizationManager.localizedString(.help))
                        }
                    }
                    
                    NavigationLink(destination: Text("Support content will be here")) {
                        HStack {
                            Image(systemName: "envelope")
                            Text(localizationManager.localizedString(.support))
                        }
                    }
                    
                    NavigationLink(destination: Text("Terms content will be here")) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text(localizationManager.localizedString(.terms))
                        }
                    }
                    
                    NavigationLink(destination: Text("Privacy policy content will be here")) {
                        HStack {
                            Image(systemName: "hand.raised")
                            Text(localizationManager.localizedString(.privacyPolicy))
                        }
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString(.settings))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                }
            }
        }
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .onAppear {
            loadSettings()
        }
    }
    
    private func themeIcon(for theme: AppTheme) -> String {
        switch theme {
        case .light: return "sun.max"
        case .dark: return "moon"
        case .system: return "gear"
        }
    }
    
    private func themeText(for theme: AppTheme) -> String {
        switch localizationManager.currentLanguage {
        case .english:
            return theme.displayName
        case .persian:
            return theme.persianName
        }
    }
    
    private func calendarText(for calendar: CalendarType) -> String {
        switch localizationManager.currentLanguage {
        case .english:
            return calendar.displayName
        case .persian:
            return calendar.persianName
        }
    }
    
    private func colorValue(for color: String) -> Color {
        switch color {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "purple": return .purple
        case "pink": return .pink
        case "yellow": return .yellow
        case "mint": return .mint
        case "teal": return .teal
        case "cyan": return .cyan
        case "indigo": return .indigo
        default: return .blue
        }
    }
    
    private func loadSettings() {
        if let settings = appSettings.first {
            selectedLanguage = settings.language
            selectedTheme = settings.theme
            selectedCalendar = settings.calendarType
            selectedPrimaryColor = settings.primaryColor
            selectedAccentColor = settings.accentColor
            
            // Apply settings to managers
            localizationManager.setLanguage(settings.language)
            themeManager.setTheme(settings.theme)
            themeManager.setPrimaryColor(settings.primaryColor)
            themeManager.setAccentColor(settings.accentColor)
        } else {
            // Create default settings
            let settings = AppSettings()
            modelContext.insert(settings)
            try? modelContext.save()
        }
    }
    
    private func saveSettings() {
        if let settings = appSettings.first {
            settings.language = selectedLanguage
            settings.theme = selectedTheme
            settings.calendarType = selectedCalendar
            settings.primaryColor = selectedPrimaryColor
            settings.accentColor = selectedAccentColor
            
            try? modelContext.save()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(LocalizationManager.shared)
        .environmentObject(ThemeManager.shared)
        .modelContainer(for: AppSettings.self, inMemory: true)
}
