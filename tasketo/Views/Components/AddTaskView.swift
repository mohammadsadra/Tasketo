import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var title = ""
    @State private var taskDescription = ""
    @State private var priority: TaskPriority = .medium
    @State private var status: TaskStatus = .pending
    @State private var dueDate: Date = Date()
    @State private var hasDueDate = false
    @State private var tags: [String] = []
    @State private var newTag = ""
    @State private var notes = ""
    @State private var calendarType: CalendarType = .gregorian
    @State private var isRecurring = false
    @State private var recurrencePattern: RecurrencePattern = .daily
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Information
                Section(header: Text(localizationManager.localizedString(.taskTitle))) {
                    TextField(localizationManager.localizedString(.taskTitle), text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField(localizationManager.localizedString(.taskDescription), text: $taskDescription, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }
                
                // Priority and Status
                Section(header: Text(localizationManager.localizedString(.priority))) {
                    Picker(localizationManager.localizedString(.priority), selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(priorityColor(for: priority))
                                    .frame(width: 12, height: 12)
                                Text(priorityText(for: priority))
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text(localizationManager.localizedString(.status))) {
                    Picker(localizationManager.localizedString(.status), selection: $status) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(statusText(for: status))
                                .tag(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Due Date
                Section(header: Text(localizationManager.localizedString(.dueDate))) {
                    Toggle(localizationManager.localizedString(.dueDate), isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker(
                            localizationManager.localizedString(.dueDate),
                            selection: $dueDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(CompactDatePickerStyle())
                        
                        Picker(localizationManager.localizedString(.calendar), selection: $calendarType) {
                            ForEach(CalendarType.allCases, id: \.self) { calendar in
                                Text(calendarText(for: calendar))
                                    .tag(calendar)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                // Recurring
                Section(header: Text(localizationManager.localizedString(.recurring))) {
                    Toggle(localizationManager.localizedString(.recurring), isOn: $isRecurring)
                    
                    if isRecurring {
                        Picker(localizationManager.localizedString(.recurring), selection: $recurrencePattern) {
                            ForEach(RecurrencePattern.allCases, id: \.self) { pattern in
                                Text(recurrenceText(for: pattern))
                                    .tag(pattern)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                // Tags
                Section(header: Text(localizationManager.localizedString(.tags))) {
                    HStack {
                        TextField(localizationManager.localizedString(.tags), text: $newTag)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: addTag) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(themeManager.primaryColorValue)
                        }
                        .disabled(newTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    
                    if !tags.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                HStack {
                                    Text(tag)
                                        .font(.caption)
                                    Button(action: { removeTag(tag) }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(themeManager.accentColorValue.opacity(0.2))
                                .foregroundColor(themeManager.accentColorValue)
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // Notes
                Section(header: Text(localizationManager.localizedString(.notes))) {
                    TextField(localizationManager.localizedString(.notes), text: $notes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...8)
                }
            }
            .navigationTitle(localizationManager.localizedString(.addTask))
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
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
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
    
    private func calendarText(for calendar: CalendarType) -> String {
        switch localizationManager.currentLanguage {
        case .english:
            return calendar.displayName
        case .persian:
            return calendar.persianName
        }
    }
    
    private func recurrenceText(for pattern: RecurrencePattern) -> String {
        switch localizationManager.currentLanguage {
        case .english:
            return pattern.displayName
        case .persian:
            return pattern.persianName
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
        let task = Task(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            taskDescription: taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            priority: priority,
            status: status,
            dueDate: hasDueDate ? dueDate : nil,
            calendarType: calendarType,
            tags: tags,
            isRecurring: isRecurring,
            recurrencePattern: isRecurring ? recurrencePattern : nil,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        modelContext.insert(task)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving task: \(error)")
        }
    }
}

#Preview {
    AddTaskView()
        .environmentObject(LocalizationManager.shared)
        .environmentObject(ThemeManager.shared)
        .modelContainer(for: Task.self, inMemory: true)
}
