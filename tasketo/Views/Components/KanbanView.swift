import SwiftUI
import SwiftData

struct KanbanView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var tasks: [Task]
    
    let searchText: String
    @State private var draggedTask: Task?
    
    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.taskDescription.localizedCaseInsensitiveContains(searchText) ||
                task.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Kanban Board
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        KanbanColumn(
                            status: status,
                            tasks: tasksForStatus(status),
                            draggedTask: $draggedTask,
                            onTaskDrop: { task in
                                updateTaskStatus(task: task, newStatus: status)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(localizationManager.localizedString(.tasks))
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func tasksForStatus(_ status: TaskStatus) -> [Task] {
        return filteredTasks.filter { $0.status == status }
    }
    
    private func updateTaskStatus(task: Task, newStatus: TaskStatus) {
        task.status = newStatus
        try? modelContext.save()
    }
}

struct KanbanColumn: View {
    let status: TaskStatus
    let tasks: [Task]
    @Binding var draggedTask: Task?
    let onTaskDrop: (Task) -> Void
    
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Column Header
            HStack {
                Text(statusText)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(tasks.count)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(statusColor.opacity(0.1))
            .cornerRadius(8)
            
            // Tasks
            LazyVStack(spacing: 8) {
                ForEach(tasks) { task in
                    KanbanTaskCard(task: task)
                        .onDrag {
                            draggedTask = task
                            return NSItemProvider(object: task.id.uuidString as NSString)
                        }
                        .onDrop(of: [.text], delegate: TaskDropDelegate(
                            draggedTask: $draggedTask,
                            targetTask: task,
                            onDrop: onTaskDrop
                        ))
                }
            }
            
            Spacer(minLength: 0)
        }
        .frame(width: 280)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onDrop(of: [.text], delegate: ColumnDropDelegate(
            draggedTask: $draggedTask,
            onDrop: onTaskDrop
        ))
    }
    
    private var statusText: String {
        switch localizationManager.currentLanguage {
        case .english:
            return status.displayName
        case .persian:
            return status.persianName
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .pending: return .orange
        case .inProgress: return .blue
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}

struct KanbanTaskCard: View {
    let task: Task
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingTaskDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Priority and Title
            HStack {
                Circle()
                    .fill(priorityColor)
                    .frame(width: 8, height: 8)
                
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Spacer()
            }
            
            // Description
            if !task.taskDescription.isEmpty {
                Text(task.taskDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            // Tags
            if !task.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(task.tags.prefix(3), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(themeManager.accentColorValue.opacity(0.2))
                                .foregroundColor(themeManager.accentColorValue)
                                .cornerRadius(6)
                        }
                    }
                }
            }
            
            // Due Date
            if let dueDate = task.dueDate {
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(CalendarHelper.shared.formatDate(dueDate, calendarType: task.calendarType, language: localizationManager.currentLanguage))
                        .font(.caption2)
                    Spacer()
                }
                .foregroundColor(dueDateColor)
            }
            
            // Subtasks Progress
            if !task.subtasks.isEmpty {
                HStack {
                    Image(systemName: "checklist")
                        .font(.caption2)
                    Text("\(completedSubtasksCount)/\(task.subtasks.count)")
                        .font(.caption2)
                    Spacer()
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
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
    
    private var dueDateColor: Color {
        guard let dueDate = task.dueDate else { return .secondary }
        
        if task.status == .completed {
            return .green
        }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(dueDate) {
            return .orange
        } else if calendar.isDateInTomorrow(dueDate) {
            return .blue
        } else if dueDate < Date() {
            return .red
        } else {
            return .secondary
        }
    }
    
    private var completedSubtasksCount: Int {
        task.subtasks.filter { $0.isCompleted }.count
    }
}

struct TaskDropDelegate: DropDelegate {
    @Binding var draggedTask: Task?
    let targetTask: Task
    let onDrop: (Task) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedTask = draggedTask else { return false }
        onDrop(draggedTask)
        self.draggedTask = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

struct ColumnDropDelegate: DropDelegate {
    @Binding var draggedTask: Task?
    let onDrop: (Task) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedTask = draggedTask else { return false }
        onDrop(draggedTask)
        self.draggedTask = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

#Preview {
    NavigationView {
        KanbanView(searchText: "")
            .environmentObject(LocalizationManager.shared)
            .environmentObject(ThemeManager.shared)
            .modelContainer(for: Task.self, inMemory: true)
    }
}
