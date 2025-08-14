import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: AppLanguage = .english
    
    private init() {}
    
    func localizedString(_ key: LocalizationKey) -> String {
        switch currentLanguage {
        case .english:
            return key.english
        case .persian:
            return key.persian
        }
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }
}

enum LocalizationKey {
    case tasks
    case addTask
    case editTask
    case deleteTask
    case taskTitle
    case taskDescription
    case priority
    case status
    case dueDate
    case tags
    case notes
    case subtasks
    case addSubtask
    case completed
    case pending
    case inProgress
    case cancelled
    case low
    case medium
    case high
    case urgent
    case today
    case tomorrow
    case yesterday
    case settings
    case language
    case theme
    case calendar
    case colors
    case primaryColor
    case accentColor
    case about
    case version
    case search
    case filter
    case sort
    case allTasks
    case completedTasks
    case pendingTasks
    case overdueTasks
    case upcomingTasks
    case save
    case cancel
    case delete
    case edit
    case done
    case back
    case next
    case previous
    case close
    case ok
    case yes
    case no
    case confirm
    case warning
    case error
    case success
    case loading
    case noTasks
    case noTasksMessage
    case createFirstTask
    case taskCreated
    case taskUpdated
    case taskDeleted
    case taskCompleted
    case taskInProgress
    case taskCancelled
    case overdue
    case dueToday
    case dueTomorrow
    case noDueDate
    case recurring
    case daily
    case weekly
    case monthly
    case yearly
    case attachments
    case addAttachment
    case removeAttachment
    case camera
    case photoLibrary
    case documents
    case share
    case export
    case importTasks
    case exportTasks
    case backup
    case restore
    case sync
    case lastSync
    case syncNow
    case syncSettings
    case notifications
    case reminder
    case taskDetails
    case basicInfo
    case deleteTaskMessage
    case title
    case description
    case reminderTime
    case sound
    case vibration
    case badge
    case privacy
    case dataUsage
    case analytics
    case feedback
    case rateApp
    case help
    case support
    case terms
    case privacyPolicy
    case acknowledgments
    case developers
    case contributors
    case openSource
    case license
    
    var english: String {
        switch self {
        case .tasks: return "Tasks"
        case .addTask: return "Add Task"
        case .editTask: return "Edit Task"
        case .deleteTask: return "Delete Task"
        case .taskTitle: return "Task Title"
        case .taskDescription: return "Description"
        case .priority: return "Priority"
        case .status: return "Status"
        case .dueDate: return "Due Date"
        case .tags: return "Tags"
        case .notes: return "Notes"
        case .subtasks: return "Subtasks"
        case .addSubtask: return "Add Subtask"
        case .completed: return "Completed"
        case .pending: return "Pending"
        case .inProgress: return "In Progress"
        case .cancelled: return "Cancelled"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        case .today: return "Today"
        case .tomorrow: return "Tomorrow"
        case .yesterday: return "Yesterday"
        case .settings: return "Settings"
        case .language: return "Language"
        case .theme: return "Theme"
        case .calendar: return "Calendar"
        case .colors: return "Colors"
        case .primaryColor: return "Primary Color"
        case .accentColor: return "Accent Color"
        case .about: return "About"
        case .version: return "Version"
        case .search: return "Search"
        case .filter: return "Filter"
        case .sort: return "Sort"
        case .allTasks: return "All Tasks"
        case .completedTasks: return "Completed Tasks"
        case .pendingTasks: return "Pending Tasks"
        case .overdueTasks: return "Overdue Tasks"
        case .upcomingTasks: return "Upcoming Tasks"
        case .save: return "Save"
        case .cancel: return "Cancel"
        case .delete: return "Delete"
        case .edit: return "Edit"
        case .done: return "Done"
        case .back: return "Back"
        case .next: return "Next"
        case .previous: return "Previous"
        case .close: return "Close"
        case .ok: return "OK"
        case .yes: return "Yes"
        case .no: return "No"
        case .confirm: return "Confirm"
        case .warning: return "Warning"
        case .error: return "Error"
        case .success: return "Success"
        case .loading: return "Loading"
        case .noTasks: return "No Tasks"
        case .noTasksMessage: return "You don't have any tasks yet"
        case .createFirstTask: return "Create your first task"
        case .taskCreated: return "Task created successfully"
        case .taskUpdated: return "Task updated successfully"
        case .taskDeleted: return "Task deleted successfully"
        case .taskCompleted: return "Task marked as completed"
        case .taskInProgress: return "Task marked as in progress"
        case .taskCancelled: return "Task cancelled"
        case .overdue: return "Overdue"
        case .dueToday: return "Due Today"
        case .dueTomorrow: return "Due Tomorrow"
        case .noDueDate: return "No Due Date"
        case .recurring: return "Recurring"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .attachments: return "Attachments"
        case .addAttachment: return "Add Attachment"
        case .removeAttachment: return "Remove Attachment"
        case .camera: return "Camera"
        case .photoLibrary: return "Photo Library"
        case .documents: return "Documents"
        case .share: return "Share"
        case .export: return "Export"
        case .importTasks: return "Import Tasks"
        case .exportTasks: return "Export Tasks"
        case .backup: return "Backup"
        case .restore: return "Restore"
        case .sync: return "Sync"
        case .lastSync: return "Last Sync"
        case .syncNow: return "Sync Now"
        case .syncSettings: return "Sync Settings"
        case .notifications: return "Notifications"
        case .reminder: return "Reminder"
        case .reminderTime: return "Reminder Time"
        case .sound: return "Sound"
        case .vibration: return "Vibration"
        case .badge: return "Badge"
        case .privacy: return "Privacy"
        case .dataUsage: return "Data Usage"
        case .analytics: return "Analytics"
        case .feedback: return "Feedback"
        case .rateApp: return "Rate App"
        case .help: return "Help"
        case .support: return "Support"
        case .terms: return "Terms of Service"
        case .privacyPolicy: return "Privacy Policy"
        case .acknowledgments: return "Acknowledgments"
        case .developers: return "Developers"
        case .contributors: return "Contributors"
        case .openSource: return "Open Source"
        case .license: return "License"
        case .taskDetails: return "Task Details"
        case .basicInfo: return "Basic Information"
        case .deleteTaskMessage: return "Are you sure you want to delete this task? This action cannot be undone."
        case .title: return "Title"
        case .description: return "Description"
        }
    }
    
    var persian: String {
        switch self {
        case .tasks: return "وظایف"
        case .addTask: return "افزودن وظیفه"
        case .editTask: return "ویرایش وظیفه"
        case .deleteTask: return "حذف وظیفه"
        case .taskTitle: return "عنوان وظیفه"
        case .taskDescription: return "توضیحات"
        case .priority: return "اولویت"
        case .status: return "وضعیت"
        case .dueDate: return "تاریخ سررسید"
        case .tags: return "برچسب‌ها"
        case .notes: return "یادداشت‌ها"
        case .subtasks: return "زیروظایف"
        case .addSubtask: return "افزودن زیروظیفه"
        case .completed: return "تکمیل شده"
        case .pending: return "در انتظار"
        case .inProgress: return "در حال انجام"
        case .cancelled: return "لغو شده"
        case .low: return "کم"
        case .medium: return "متوسط"
        case .high: return "زیاد"
        case .urgent: return "فوری"
        case .today: return "امروز"
        case .tomorrow: return "فردا"
        case .yesterday: return "دیروز"
        case .settings: return "تنظیمات"
        case .language: return "زبان"
        case .theme: return "تم"
        case .calendar: return "تقویم"
        case .colors: return "رنگ‌ها"
        case .primaryColor: return "رنگ اصلی"
        case .accentColor: return "رنگ تاکیدی"
        case .about: return "درباره"
        case .version: return "نسخه"
        case .search: return "جستجو"
        case .filter: return "فیلتر"
        case .sort: return "مرتب‌سازی"
        case .allTasks: return "همه وظایف"
        case .completedTasks: return "وظایف تکمیل شده"
        case .pendingTasks: return "وظایف در انتظار"
        case .overdueTasks: return "وظایف معوق"
        case .upcomingTasks: return "وظایف آینده"
        case .save: return "ذخیره"
        case .cancel: return "لغو"
        case .delete: return "حذف"
        case .edit: return "ویرایش"
        case .done: return "انجام شد"
        case .back: return "بازگشت"
        case .next: return "بعدی"
        case .previous: return "قبلی"
        case .close: return "بستن"
        case .ok: return "تایید"
        case .yes: return "بله"
        case .no: return "خیر"
        case .confirm: return "تایید"
        case .warning: return "هشدار"
        case .error: return "خطا"
        case .success: return "موفقیت"
        case .loading: return "در حال بارگذاری"
        case .noTasks: return "هیچ وظیفه‌ای وجود ندارد"
        case .noTasksMessage: return "هنوز هیچ وظیفه‌ای ندارید"
        case .createFirstTask: return "اولین وظیفه خود را ایجاد کنید"
        case .taskCreated: return "وظیفه با موفقیت ایجاد شد"
        case .taskUpdated: return "وظیفه با موفقیت به‌روزرسانی شد"
        case .taskDeleted: return "وظیفه با موفقیت حذف شد"
        case .taskCompleted: return "وظیفه به عنوان تکمیل شده علامت‌گذاری شد"
        case .taskInProgress: return "وظیفه به عنوان در حال انجام علامت‌گذاری شد"
        case .taskCancelled: return "وظیفه لغو شد"
        case .overdue: return "معوق"
        case .dueToday: return "سررسید امروز"
        case .dueTomorrow: return "سررسید فردا"
        case .noDueDate: return "بدون تاریخ سررسید"
        case .recurring: return "تکرار شونده"
        case .daily: return "روزانه"
        case .weekly: return "هفتگی"
        case .monthly: return "ماهانه"
        case .yearly: return "سالانه"
        case .attachments: return "پیوست‌ها"
        case .addAttachment: return "افزودن پیوست"
        case .removeAttachment: return "حذف پیوست"
        case .camera: return "دوربین"
        case .photoLibrary: return "کتابخانه عکس"
        case .documents: return "اسناد"
        case .share: return "اشتراک‌گذاری"
        case .export: return "خروجی"
        case .importTasks: return "وارد کردن وظایف"
        case .exportTasks: return "خروجی وظایف"
        case .backup: return "پشتیبان‌گیری"
        case .restore: return "بازیابی"
        case .sync: return "همگام‌سازی"
        case .lastSync: return "آخرین همگام‌سازی"
        case .syncNow: return "همگام‌سازی اکنون"
        case .syncSettings: return "تنظیمات همگام‌سازی"
        case .notifications: return "اعلان‌ها"
        case .reminder: return "یادآوری"
        case .reminderTime: return "زمان یادآوری"
        case .sound: return "صدا"
        case .vibration: return "لرزش"
        case .badge: return "نشان"
        case .privacy: return "حریم خصوصی"
        case .dataUsage: return "استفاده از داده"
        case .analytics: return "تحلیل‌ها"
        case .feedback: return "بازخورد"
        case .rateApp: return "امتیازدهی به برنامه"
        case .help: return "راهنما"
        case .support: return "پشتیبانی"
        case .terms: return "شرایط استفاده"
        case .privacyPolicy: return "سیاست حریم خصوصی"
        case .acknowledgments: return "تشکر و قدردانی"
        case .developers: return "توسعه‌دهندگان"
        case .contributors: return "مشارکت‌کنندگان"
        case .openSource: return "متن باز"
        case .license: return "مجوز"
        case .taskDetails: return "جزئیات وظیفه"
        case .basicInfo: return "اطلاعات پایه"
        case .deleteTaskMessage: return "آیا مطمئن هستید که می‌خواهید این وظیفه را حذف کنید؟ این عمل قابل بازگشت نیست."
        case .title: return "عنوان"
        case .description: return "توضیحات"
        }
    }
}
