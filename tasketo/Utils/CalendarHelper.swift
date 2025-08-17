import Foundation

class CalendarHelper {
    static let shared = CalendarHelper()
    
    private let gregorianCalendar = Calendar(identifier: .gregorian)
    private let persianCalendar = Calendar(identifier: .persian)
    
    private init() {}
    
    // MARK: - UTC Date Handling
    
    /// Convert a date to UTC for storage
    func toUTC(_ date: Date) -> Date {
        let timeZone = TimeZone.current
        let offset = timeZone.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(offset))
    }
    
    /// Convert a UTC date to local time for display
    func fromUTC(_ date: Date) -> Date {
        let timeZone = TimeZone.current
        let offset = timeZone.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(-offset))
    }
    
    // MARK: - Calendar Conversions
    
    /// Convert a date from one calendar to another
    func convertDate(_ date: Date, from sourceCalendar: CalendarType, to targetCalendar: CalendarType) -> Date {
        guard sourceCalendar != targetCalendar else { return date }
        
        let sourceCal = sourceCalendar == .gregorian ? gregorianCalendar : persianCalendar
        let targetCal = targetCalendar == .gregorian ? gregorianCalendar : persianCalendar
        
        let components = sourceCal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return targetCal.date(from: components) ?? date
    }
    
    /// Convert a date to the specified calendar type for display
    func convertToCalendar(_ date: Date, calendarType: CalendarType) -> Date {
        // First convert from UTC to local time
        let localDate = fromUTC(date)
        
        // Then convert to the target calendar if needed
        // For now, we'll use the same date but format it according to the calendar
        return localDate
    }
    
    // MARK: - Date Formatting
    
    func formatDate(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        
        // Convert UTC date to local time for display
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
            formatter.locale = Locale(identifier: language.locale)
            formatter.dateStyle = .medium
        case .shamsi:
            formatter.calendar = persianCalendar
            formatter.locale = Locale(identifier: language.locale)
            formatter.dateStyle = .medium
            // For Shamsi calendar, we need to ensure the date is properly converted
            if let shamsiDate = convertToShamsi(localDate) {
                return formatter.string(from: shamsiDate)
            }
        }
        
        return formatter.string(from: localDate)
    }
    
    /// Convert a Gregorian date to Shamsi date
    private func convertToShamsi(_ date: Date) -> Date? {
        let gregorianComponents = gregorianCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return persianCalendar.date(from: gregorianComponents)
    }
    
    func formatDateTime(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        
        // Convert UTC date to local time for display
        let localDate = fromUTC(date)
        
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
        
        return formatter.string(from: localDate)
    }
    
    func getRelativeDateString(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: language.locale)
        
        // Convert UTC date to local time for display
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
        case .shamsi:
            formatter.calendar = persianCalendar
        }
        
        return formatter.localizedString(for: localDate, relativeTo: Date())
    }
    
    // MARK: - Date Comparisons
    
    func isToday(_ date: Date, calendarType: CalendarType) -> Bool {
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            return gregorianCalendar.isDateInToday(localDate)
        case .shamsi:
            if let shamsiDate = convertToShamsi(localDate) {
                return persianCalendar.isDateInToday(shamsiDate)
            }
            return false
        }
    }
    
    func isTomorrow(_ date: Date, calendarType: CalendarType) -> Bool {
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            return gregorianCalendar.isDateInTomorrow(localDate)
        case .shamsi:
            if let shamsiDate = convertToShamsi(localDate) {
                return persianCalendar.isDateInTomorrow(shamsiDate)
            }
            return false
        }
    }
    
    func isYesterday(_ date: Date, calendarType: CalendarType) -> Bool {
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            return gregorianCalendar.isDateInYesterday(localDate)
        case .shamsi:
            if let shamsiDate = convertToShamsi(localDate) {
                return persianCalendar.isDateInYesterday(shamsiDate)
            }
            return false
        }
    }
    
    func isOverdue(_ date: Date, calendarType: CalendarType) -> Bool {
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            return localDate < Date()
        case .shamsi:
            if let shamsiDate = convertToShamsi(localDate) {
                let today = Date()
                if let todayShamsi = convertToShamsi(today) {
                    return shamsiDate < todayShamsi
                }
            }
            return localDate < Date()
        }
    }
    
    // MARK: - Date Components
    
    func getWeekdayName(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: language.locale)
        
        // Convert UTC date to local time for display
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
        case .shamsi:
            formatter.calendar = persianCalendar
        }
        
        formatter.dateFormat = "EEEE"
        return formatter.string(from: localDate)
    }
    
    func getMonthName(_ date: Date, calendarType: CalendarType, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: language.locale)
        
        // Convert UTC date to local time for display
        let localDate = fromUTC(date)
        
        switch calendarType {
        case .gregorian:
            formatter.calendar = gregorianCalendar
        case .shamsi:
            formatter.calendar = persianCalendar
        }
        
        formatter.dateFormat = "MMMM"
        return formatter.string(from: localDate)
    }
    
    // MARK: - Date Creation
    
    /// Create a UTC date from components in the specified calendar
    func createDate(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, calendarType: CalendarType) -> Date? {
        let calendar = calendarType == .gregorian ? gregorianCalendar : persianCalendar
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        guard let date = calendar.date(from: components) else { return nil }
        return toUTC(date)
    }
    
    /// Get current date in UTC
    func currentDateUTC() -> Date {
        return toUTC(Date())
    }
}
