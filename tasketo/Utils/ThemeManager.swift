import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme = .system
    @Published var appColor: String = "blue"
    
    private init() {}
    
    var colorScheme: ColorScheme? {
        switch currentTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    var appColorValue: Color {
        switch appColor {
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
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
    
    func setAppColor(_ color: String) {
        appColor = color
        print("App color changed to: \(color)")
        objectWillChange.send()
    }
    
    static let availableColors = [
        "blue", "green", "orange", "red", "purple", 
        "pink", "yellow", "mint", "teal", "cyan", "indigo"
    ]
    
    static func colorName(for color: String) -> String {
        switch color {
        case "blue": return "Blue"
        case "green": return "Green"
        case "orange": return "Orange"
        case "red": return "Red"
        case "purple": return "Purple"
        case "pink": return "Pink"
        case "yellow": return "Yellow"
        case "mint": return "Mint"
        case "teal": return "Teal"
        case "cyan": return "Cyan"
        case "indigo": return "Indigo"
        default: return "Blue"
        }
    }
    
    static func persianColorName(for color: String) -> String {
        switch color {
        case "blue": return "آبی"
        case "green": return "سبز"
        case "orange": return "نارنجی"
        case "red": return "قرمز"
        case "purple": return "بنفش"
        case "pink": return "صورتی"
        case "yellow": return "زرد"
        case "mint": return "نعناعی"
        case "teal": return "فیروزه‌ای"
        case "cyan": return "آبی روشن"
        case "indigo": return "نیلی"
        default: return "آبی"
        }
    }
}
