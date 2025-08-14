import SwiftUI
import SwiftData

struct TaskDetailView: View {
    let task: Task
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var showingEditTask = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(priorityColor)
                                .frame(width: 12, height: 12)
                            
                            Text(task.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(nil)
                            
                            Spacer()
                        }
                        
                        if !task.taskDescription.isEmpty {
                            Text(task.taskDescription)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Status and Priority Section
                    HStack(spacing: 16) {
                        // Status
                        VStack(alignment: .leading, spacing: 4) {
                            Text(localizationManager.localizedString(.status))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Circle()
                                    .fill(statusColor)
                                    .frame(width: 8, height: 8)
                                Text(statusText)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        
                        Spacer()
                        
                        // Priority
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(localizationManager.localizedString(.priority))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Circle()
                                    .fill(priorityColor)
                                    .frame(width: 8, height: 8)
                                Text(priorityText)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Due Date Section
                    if let dueDate = task.dueDate {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizationManager.localizedString(.dueDate))
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(dueDateColor)
                                Text(CalendarHelper.shared.formatDate(dueDate, calendarType: task.calendarType, language: localizationManager.currentLanguage))
                                    .foregroundColor(dueDateColor)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Tags Section
                    if !task.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizationManager.localizedString(.tags))
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(task.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(themeManager.accentColorValue.opacity(0.2))
                                        .foregroundColor(themeManager.accentColorValue)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Subtasks Section
                    if !task.subtasks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(localizationManager.localizedString(.subtasks))
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("\(completedSubtasksCount)/\(task.subtasks.count)")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(themeManager.primaryColorValue.opacity(0.2))
                                    .foregroundColor(themeManager.primaryColorValue)
                                    .clipShape(Capsule())
                            }
                            
                            VStack(spacing: 8) {
                                ForEach(task.subtasks) { subtask in
                                    HStack {
                                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(subtask.isCompleted ? .green : .secondary)
                                            .onTapGesture {
                                                toggleSubtask(subtask)
                                            }
                                        
                                        Text(subtask.title)
                                            .strikethrough(subtask.isCompleted)
                                            .foregroundColor(subtask.isCompleted ? .secondary : .primary)
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Notes Section
                    if !task.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizationManager.localizedString(.notes))
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(task.notes)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Created Date
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Created: \(CalendarHelper.shared.formatDate(task.createdDate, calendarType: task.calendarType, language: localizationManager.currentLanguage))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle(localizationManager.localizedString(.taskDetails))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localizationManager.localizedString(.close)) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: { showingEditTask = true }) {
                            Image(systemName: "pencil")
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditTask) {
            EditTaskView(task: task)
        }
        .alert(localizationManager.localizedString(.deleteTask), isPresented: $showingDeleteAlert) {
            Button(localizationManager.localizedString(.delete), role: .destructive) {
                deleteTask()
            }
            Button(localizationManager.localizedString(.cancel), role: .cancel) { }
        } message: {
            Text(localizationManager.localizedString(.deleteTaskMessage))
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
    
    private var priorityText: String {
        switch localizationManager.currentLanguage {
        case .english:
            return task.priority.displayName
        case .persian:
            return task.priority.persianName
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
    
    private var statusText: String {
        switch localizationManager.currentLanguage {
        case .english:
            return task.status.displayName
        case .persian:
            return task.status.persianName
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
    
    private func toggleSubtask(_ subtask: Subtask) {
        subtask.isCompleted.toggle()
        if subtask.isCompleted {
            subtask.completedDate = Date()
        } else {
            subtask.completedDate = nil
        }
        try? modelContext.save()
    }
    
    private func deleteTask() {
        modelContext.delete(task)
        try? modelContext.save()
        dismiss()
    }
}

struct EditTaskView: View {
    let task: Task
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var title: String
    @State private var taskDescription: String
    @State private var priority: TaskPriority
    @State private var status: TaskStatus
    @State private var dueDate: Date?
    @State private var tags: [String]
    @State private var notes: String
    @State private var newTag: String = ""
    
    init(task: Task) {
        self.task = task
        _title = State(initialValue: task.title)
        _taskDescription = State(initialValue: task.taskDescription)
        _priority = State(initialValue: task.priority)
        _status = State(initialValue: task.status)
        _dueDate = State(initialValue: task.dueDate)
        _tags = State(initialValue: task.tags)
        _notes = State(initialValue: task.notes)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(localizationManager.localizedString(.basicInfo))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField(localizationManager.localizedString(.title), text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField(localizationManager.localizedString(.description), text: $taskDescription, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Priority Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(localizationManager.localizedString(.priority))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Picker(localizationManager.localizedString(.priority), selection: $priority) {
                            ForEach(TaskPriority.allCases, id: \.self) { priority in
                                Text(priorityText(for: priority)).tag(priority)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Status Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(localizationManager.localizedString(.status))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Picker(localizationManager.localizedString(.status), selection: $status) {
                            ForEach(TaskStatus.allCases, id: \.self) { status in
                                Text(statusText(for: status)).tag(status)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Due Date Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(localizationManager.localizedString(.dueDate))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        DatePicker(localizationManager.localizedString(.dueDate), selection: Binding(
                            get: { dueDate ?? Date() },
                            set: { dueDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Tags Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(localizationManager.localizedString(.tags))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ForEach(tags, id: \.self) { tag in
                            HStack {
                                Text(tag)
                                Spacer()
                                Button(action: { removeTag(tag) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        
                        HStack {
                            TextField("Add tag", text: $newTag)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Add") {
                                addTag()
                            }
                            .disabled(newTag.isEmpty)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(localizationManager.localizedString(.notes))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField(localizationManager.localizedString(.notes), text: $notes, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle(localizationManager.localizedString(.editTask))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localizationManager.localizedString(.cancel)) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.save)) {
                        saveTask()
                    }
                }
            }
        }
    }
    
    private func priorityText(for priority: TaskPriority) -> String {
        switch localizationManager.currentLanguage {
        case .english:
            return priority.displayName
        case .persian:
            return priority.persianName
        }
    }
    
    private func statusText(for status: TaskStatus) -> String {
        switch localizationManager.currentLanguage {
        case .english:
            return status.displayName
        case .persian:
            return status.persianName
        }
    }
    
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            newTag = ""
        }
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    private func saveTask() {
        task.title = title
        task.taskDescription = taskDescription
        task.priority = priority
        task.status = status
        task.dueDate = dueDate
        task.tags = tags
        task.notes = notes
        
        dismiss()
    }
}

#Preview {
    TaskDetailView(task: Task(title: "Sample Task", taskDescription: "This is a sample task description", priority: .high, status: .inProgress))
        .environmentObject(LocalizationManager.shared)
        .environmentObject(ThemeManager.shared)
        .modelContainer(for: Task.self, inMemory: true)
}
