//
//  tasketoApp.swift
//  tasketo
//
//  Created by Mohammadsadra on 8/13/25.
//

import SwiftUI
import SwiftData

@main
struct tasketoApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Task.self,
            Subtask.self,
            AppSettings.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(localizationManager)
                .environmentObject(themeManager)
                .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
                .preferredColorScheme(themeManager.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
