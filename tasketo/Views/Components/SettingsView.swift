import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var appSettings: [AppSettings]
    
    @State private var selectedLanguage: AppLanguage = .english
    @State private var selectedTheme: AppTheme = .system
    @State private var selectedCalendar: CalendarType = .gregorian
    @State private var selectedAppColor: String = "blue"
    
    var body: some View {
        NavigationView {
            Form {
                // Language Settings
                Section {
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
                } header: {
                    Text(localizationManager.localizedString(.language))
                }
                
                // Theme Settings
                Section {
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
                } header: {
                    Text(localizationManager.localizedString(.theme))
                }
                
                // Calendar Settings
                Section {
                    Picker(localizationManager.localizedString(.calendar), selection: $selectedCalendar) {
                        ForEach(CalendarType.allCases, id: \.self) { calendar in
                            Text(calendarText(for: calendar))
                                .tag(calendar)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedCalendar) { _, newValue in
                        saveSettings()
                        // Trigger UI refresh by updating the environment
                        themeManager.objectWillChange.send()
                    }
                } header: {
                    Text(localizationManager.localizedString(.calendar))
                }
                
                // Color Settings
                Section {
                    VStack(alignment: localizationManager.currentLanguage.isRTL ? .trailing : .leading, spacing: 6) {
                        Text(localizationManager.localizedString(.primaryColor))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
                            ForEach(ThemeManager.availableColors, id: \.self) { color in
                                Button(action: {
                                    print("App color button tapped: \(color)")
                                    selectedAppColor = color
                                    themeManager.setAppColor(color)
                                    saveSettings()
                                }) {
                                    Circle()
                                        .fill(colorValue(for: color))
                                        .frame(width: 45, height: 45)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedAppColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text(localizationManager.localizedString(.colors))
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
        }
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .onAppear {
            loadSettings()
        }
        .onChange(of: localizationManager.currentLanguage) { _, _ in
            // Force view refresh when language changes
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
            selectedAppColor = settings.primaryColor // Use primaryColor as appColor
            
            // Apply settings to managers
            localizationManager.setLanguage(settings.language)
            themeManager.setTheme(settings.theme)
            themeManager.setAppColor(settings.primaryColor)
        } else {
            // Create default settings
            let settings = AppSettings()
            modelContext.insert(settings)
            try? modelContext.save()
        }
    }
    
    private func saveSettings() {
        if let settings = appSettings.first {
            let previousCalendarType = settings.calendarType
            settings.language = selectedLanguage
            settings.theme = selectedTheme
            settings.calendarType = selectedCalendar
            settings.primaryColor = selectedAppColor // Save appColor as primaryColor
            settings.accentColor = selectedAppColor // Also save as accentColor for compatibility
            
            // If calendar type changed, update all tasks to use the new calendar type
            if previousCalendarType != selectedCalendar {
                updateTasksCalendarType(to: selectedCalendar)
            }
            
            try? modelContext.save()
        }
    }
    
    private func updateTasksCalendarType(to newCalendarType: CalendarType) {
        // This function would update all existing tasks to use the new calendar type
        // For now, we'll just update the calendar type for display purposes
        // The actual date conversion would be more complex and depends on the specific requirements
        print("Calendar type changed to: \(newCalendarType)")
    }
}

#Preview {
    SettingsView()
        .environmentObject(LocalizationManager.shared)
        .environmentObject(ThemeManager.shared)
        .modelContainer(for: AppSettings.self, inMemory: true)
}
