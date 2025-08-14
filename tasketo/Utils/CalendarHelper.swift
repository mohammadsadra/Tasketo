import Foundation

class CalendarHelper {
    static let shared = CalendarHelper()
    
    private let gregorianCalendar = Calendar(identifier: .gregorian)
    private let persianCalendar = Calendar(identifier: .persian)
    
    private init() {}
    
    func convertToShamsi(_ date: Date) -> Date {
        let components = gregorianCalendar.dateComponents([.year, .month, .day], from: date)
        return persianCalendar.date(from: components) ?? date
    }
    
    func convertToGregorian(_ date: Date) -> Date {
        let components = persianCalendar.dateComponents([.year, .month, .day], from: date)
        return gregorianCalendar.date(from: components) ?? date
    }
    
    func formatDate(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
            formatter.locale = Locale(identifier: language.locale)
            formatter.dateStyle = .medium
        case .shamsi:
            formatter.calendar = persianCalendar
            formatter.locale = Locale(identifier: language.locale)
            formatter.dateStyle = .medium
        }
        
        return formatter.string(from: date)
    }
    
    func formatDateTime(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
            formatter.locale = Locale(identifier: language.locale)
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
        case .shamsi:
            formatter.calendar = persianCalendar
            formatter.locale = Locale(identifier: language.locale)
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
        }
        
        return formatter.string(from: date)
    }
    
    func getRelativeDateString(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: language.locale)
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
        case .shamsi:
            formatter.calendar = persianCalendar
        }
        
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func isToday(_ date: Date, calendarType: CalendarType) -> Bool {
        let calendar = calendarType == .gregorian ? gregorianCalendar : persianCalendar
        return calendar.isDateInToday(date)
    }
    
    func isTomorrow(_ date: Date, calendarType: CalendarType) -> Bool {
        let calendar = calendarType == .gregorian ? gregorianCalendar : persianCalendar
        return calendar.isDateInTomorrow(date)
    }
    
    func isYesterday(_ date: Date, calendarType: CalendarType) -> Bool {
        let calendar = calendarType == .gregorian ? gregorianCalendar : persianCalendar
        return calendar.isDateInYesterday(date)
    }
    
    func getWeekdayName(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: language.locale)
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
        case .shamsi:
            formatter.calendar = persianCalendar
        }
        
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    func getMonthName(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: language.locale)
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
        case .shamsi:
            formatter.calendar = persianCalendar
        }
        
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
}
