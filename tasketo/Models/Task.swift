import Foundation
import SwiftData

@Model
public final class Task {
    public var id: UUID
    var title: String
    var taskDescription: String
    var priority: TaskPriority
    var status: TaskStatus
    var dueDate: Date?
    var createdDate: Date
    var completedDate: Date?
    var calendarType: CalendarType
    var tags: [String]
    var isRecurring: Bool
    var recurrencePattern: RecurrencePattern?
    var subtasks: [Subtask]
    var attachments: [String] // File paths or URLs
    var notes: String
    
    public init(
        title: String,
        taskDescription: String = "",
        priority: TaskPriority = .medium,
        status: TaskStatus = .pending,
        dueDate: Date? = nil,
        calendarType: CalendarType = .gregorian,
        tags: [String] = [],
        isRecurring: Bool = false,
        recurrencePattern: RecurrencePattern? = nil,
        notes: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.taskDescription = taskDescription
        self.priority = priority
        self.status = status
        self.dueDate = dueDate
        self.createdDate = Date()
        self.calendarType = calendarType
        self.tags = tags
        self.isRecurring = isRecurring
        self.recurrencePattern = recurrencePattern
        self.subtasks = []
        self.attachments = []
        self.notes = notes
    }
}

public enum TaskPriority: Int, CaseIterable, Codable {
    case low = 0
    case medium = 1
    case high = 2
    case urgent = 3
    
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        }
    }
    
    var persianName: String {
        switch self {
        case .low: return "کم"
        case .medium: return "متوسط"
        case .high: return "زیاد"
        case .urgent: return "فوری"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "blue"
        case .high: return "orange"
        case .urgent: return "red"
        }
    }
}

public enum TaskStatus: Int, CaseIterable, Codable {
    case pending = 0
    case inProgress = 1
    case completed = 2
    case cancelled = 3
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        }
    }
    
    var persianName: String {
        switch self {
        case .pending: return "در انتظار"
        case .inProgress: return "در حال انجام"
        case .completed: return "تکمیل شده"
        case .cancelled: return "لغو شده"
        }
    }
}

public enum CalendarType: Int, CaseIterable, Codable {
    case gregorian = 0
    case shamsi = 1
    
    var displayName: String {
        switch self {
        case .gregorian: return "Gregorian"
        case .shamsi: return "Shamsi"
        }
    }
    
    var persianName: String {
        switch self {
        case .gregorian: return "میلادی"
        case .shamsi: return "شمسی"
        }
    }
}

public enum RecurrencePattern: Int, CaseIterable, Codable {
    case daily = 0
    case weekly = 1
    case monthly = 2
    case yearly = 3
    
    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }
    
    var persianName: String {
        switch self {
        case .daily: return "روزانه"
        case .weekly: return "هفتگی"
        case .monthly: return "ماهانه"
        case .yearly: return "سالانه"
        }
    }
}
