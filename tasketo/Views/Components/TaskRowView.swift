import SwiftUI
import SwiftData

struct TaskRowView: View {
    let task: Task
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Query private var appSettings: [AppSettings]
    @State private var showingTaskDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Priority indicator
                Circle()
                    .fill(priorityColor)
                    .frame(width: 12, height: 12)
                
                // Task title
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Spacer()
                
                // Status indicator
                statusBadge
            }
            
            if !task.taskDescription.isEmpty {
                Text(task.taskDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            HStack {
                // Due date
                if let dueDate = task.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text(CalendarHelper.shared.formatDate(dueDate, calendarType: currentCalendarType, language: localizationManager.currentLanguage))
                            .font(.caption)
                    }
                    .foregroundColor(dueDateColor)
                }
                
                Spacer()
                
                // Tags
                if !task.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(task.tags.prefix(3), id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                                                .background(themeManager.appColorValue.opacity(0.2))
                            .foregroundColor(themeManager.appColorValue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
            // Subtasks progress
            if !task.subtasks.isEmpty {
                HStack {
                    Image(systemName: "checklist")
                        .font(.caption)
                    Text("\(completedSubtasksCount)/\(task.subtasks.count)")
                        .font(.caption)
                    Spacer()
                }
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onTapGesture {
            showingTaskDetail = true
        }
        .sheet(isPresented: $showingTaskDetail) {
            TaskDetailView(task: task)
        }
    }
    
    private var priorityColor: Color {
        switch task.priority {
        case .low: return .green
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
        }
    }
    
    private var statusBadge: some View {
        Text(statusText)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
    
    private var statusText: String {
        switch task.status {
        case .pending:
            return localizationManager.localizedString(.pending)
        case .inProgress:
            return localizationManager.localizedString(.inProgress)
        case .completed:
            return localizationManager.localizedString(.completed)
        case .cancelled:
            return localizationManager.localizedString(.cancelled)
        }
    }
    
    private var statusColor: Color {
        switch task.status {
        case .pending: return .orange
        case .inProgress: return .blue
        case .completed: return .green
        case .cancelled: return .red
        }
    }
    
    private var dueDateColor: Color {
        guard let dueDate = task.dueDate else { return .secondary }
        
        if task.status == .completed {
            return .green
        }
        
        if CalendarHelper.shared.isToday(dueDate, calendarType: currentCalendarType) {
            return .orange
        } else if CalendarHelper.shared.isTomorrow(dueDate, calendarType: currentCalendarType) {
            return .blue
        } else if CalendarHelper.shared.isOverdue(dueDate, calendarType: currentCalendarType) {
            return .red
        } else {
            return .secondary
        }
    }
    
    private var completedSubtasksCount: Int {
        task.subtasks.filter { $0.isCompleted }.count
    }
    
    private var currentCalendarType: CalendarType {
        return appSettings.first?.calendarType ?? .gregorian
    }
}

#Preview {
    TaskRowView(task: Task(title: "Sample Task", taskDescription: "This is a sample task description", priority: .high, status: .inProgress, dueDate: Date().addingTimeInterval(86400), tags: ["work", "important"]))
        .environmentObject(LocalizationManager.shared)
        .environmentObject(ThemeManager.shared)
        .modelContainer(for: [Task.self, AppSettings.self], inMemory: true)
        .padding()
}
