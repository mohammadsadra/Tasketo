import Foundation
import SwiftData

@Model
public final class AppSettings {
    public var id: UUID
    var language: AppLanguage
    var theme: AppTheme
    var calendarType: CalendarType
    var primaryColor: String
    var accentColor: String
    var isFirstLaunch: Bool
    var lastSyncDate: Date?
    
    public init() {
        self.id = UUID()
        self.language = .english
        self.theme = .system
        self.calendarType = .gregorian
        self.primaryColor = "blue"
        self.accentColor = "orange"
        self.isFirstLaunch = true
    }
}

public enum AppLanguage: Int, CaseIterable, Codable {
    case english = 0
    case persian = 1
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .persian: return "فارسی"
        }
    }
    
    var locale: String {
        switch self {
        case .english: return "en"
        case .persian: return "fa"
        }
    }
    
    var isRTL: Bool {
        switch self {
        case .english: return false
        case .persian: return true
        }
    }
}

public enum AppTheme: Int, CaseIterable, Codable {
    case light = 0
    case dark = 1
    case system = 2
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
    
    var persianName: String {
        switch self {
        case .light: return "روشن"
        case .dark: return "تیره"
        case .system: return "سیستم"
        }
    }
}
