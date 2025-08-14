import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var tasks: [Task]
    @Query private var appSettings: [AppSettings]
    
    @State private var selectedTab = 0
    @State private var showingAddTask = false
    @State private var searchText = ""
    @State private var selectedFilter: TaskFilter = .all
    @State private var selectedSort: TaskSort = .dueDate
    @State private var viewMode: TaskViewMode = .kanban
    
    var filteredTasks: [Task] {
        var filtered = tasks
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.taskDescription.localizedCaseInsensitiveContains(searchText) ||
                task.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Apply status filter
        switch selectedFilter {
        case .all:
            break
        case .pending:
            filtered = filtered.filter { $0.status == .pending }
        case .inProgress:
            filtered = filtered.filter { $0.status == .inProgress }
        case .completed:
            filtered = filtered.filter { $0.status == .completed }
        case .overdue:
            filtered = filtered.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate < Date() && task.status != .completed
            }
        case .today:
            filtered = filtered.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return Calendar.current.isDateInToday(dueDate)
            }
        case .upcoming:
            filtered = filtered.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate > Date() && task.status != .completed
            }
        }
        
        // Apply sorting
        switch selectedSort {
        case .dueDate:
            filtered.sort { task1, task2 in
                guard let date1 = task1.dueDate, let date2 = task2.dueDate else {
                    return task1.dueDate != nil
                }
                return date1 < date2
            }
        case .priority:
            filtered.sort { $0.priority.rawValue > $1.priority.rawValue }
        case .title:
            filtered.sort { $0.title < $1.title }
        case .createdDate:
            filtered.sort { $0.createdDate > $1.createdDate }
        case .status:
            filtered.sort { $0.status.rawValue < $1.status.rawValue }
        }
        
        return filtered
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tasks Tab
            NavigationView {
                VStack {
                    // Search and Filter Bar
                    VStack(spacing: 12) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField(localizationManager.localizedString(.search), text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Filter, Sort, and View Mode
                        HStack {
                            // Filter Picker
                            Menu {
                                ForEach(TaskFilter.allCases, id: \.self) { filter in
                                    Button(filterText(for: filter)) {
                                        selectedFilter = filter
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                    Text(filterText(for: selectedFilter))
                                }
                                .foregroundColor(themeManager.primaryColorValue)
                            }
                            
                            Spacer()
                            
                            // View Mode Picker (only show for list view)
                            if viewMode == .list {
                                Menu {
                                    ForEach(TaskViewMode.allCases, id: \.self) { mode in
                                        Button(viewModeText(for: mode)) {
                                            viewMode = mode
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: viewMode.icon)
                                        Text(viewModeText(for: viewMode))
                                    }
                                    .foregroundColor(themeManager.primaryColorValue)
                                }
                            }
                            
                            // Sort Picker (only show for list view)
                            if viewMode == .list {
                                Menu {
                                    ForEach(TaskSort.allCases, id: \.self) { sort in
                                        Button(sortText(for: sort)) {
                                            selectedSort = sort
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.up.arrow.down")
                                        Text(sortText(for: selectedSort))
                                    }
                                    .foregroundColor(themeManager.primaryColorValue)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Tasks Content
                    if filteredTasks.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "checklist")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            Text(localizationManager.localizedString(.noTasks))
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(localizationManager.localizedString(.noTasksMessage))
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: { showingAddTask = true }) {
                                Text(localizationManager.localizedString(.createFirstTask))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(themeManager.primaryColorValue)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        if viewMode == .list {
                            List {
                                ForEach(filteredTasks) { task in
                                    TaskRowView(task: task)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .padding(.vertical, 4)
                                }
                                .onDelete(perform: deleteTasks)
                            }
                            .listStyle(PlainListStyle())
                        } else {
                            KanbanView(searchText: searchText)
                        }
                    }
                }
                .navigationTitle(localizationManager.localizedString(.tasks))
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            // View Mode Toggle
                            Button(action: {
                                viewMode = viewMode == .list ? .kanban : .list
                            }) {
                                Image(systemName: viewMode == .list ? "rectangle.grid.2x2" : "list.bullet")
                                    .foregroundColor(themeManager.primaryColorValue)
                            }
                            
                            Button(action: { showingAddTask = true }) {
                                Image(systemName: "plus")
                                    .foregroundColor(themeManager.primaryColorValue)
                            }
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: "checklist")
                Text(localizationManager.localizedString(.tasks))
            }
            .tag(0)
            
            // Calendar Tab (placeholder)
            NavigationView {
                VStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("Calendar View")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Calendar functionality will be implemented here")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .navigationTitle("Calendar")
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Calendar")
            }
            .tag(1)
            
            // Statistics Tab (placeholder)
            NavigationView {
                VStack {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("Statistics")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Statistics and analytics will be shown here")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .navigationTitle("Statistics")
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Statistics")
            }
            .tag(2)
            
            // Settings Tab
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text(localizationManager.localizedString(.settings))
            }
            .tag(3)
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .preferredColorScheme(themeManager.colorScheme)
        .onAppear {
            loadSettings()
        }
    }
    
    private func filterText(for filter: TaskFilter) -> String {
        switch filter {
        case .all: return localizationManager.localizedString(.allTasks)
        case .pending: return localizationManager.localizedString(.pendingTasks)
        case .inProgress: return localizationManager.localizedString(.inProgress)
        case .completed: return localizationManager.localizedString(.completedTasks)
        case .overdue: return localizationManager.localizedString(.overdueTasks)
        case .today: return localizationManager.localizedString(.dueToday)
        case .upcoming: return localizationManager.localizedString(.upcomingTasks)
        }
    }
    
    private func sortText(for sort: TaskSort) -> String {
        switch sort {
        case .dueDate: return "Due Date"
        case .priority: return localizationManager.localizedString(.priority)
        case .title: return "Title"
        case .createdDate: return "Created"
        case .status: return localizationManager.localizedString(.status)
        }
    }
    
    private func viewModeText(for mode: TaskViewMode) -> String {
        switch localizationManager.currentLanguage {
        case .english:
            return mode.displayName
        case .persian:
            return mode.persianName
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let task = filteredTasks[index]
                modelContext.delete(task)
            }
            try? modelContext.save()
        }
    }
    
    private func loadSettings() {
        if let settings = appSettings.first {
            localizationManager.setLanguage(settings.language)
            themeManager.setTheme(settings.theme)
            themeManager.setPrimaryColor(settings.primaryColor)
            themeManager.setAccentColor(settings.accentColor)
        }
    }
}

enum TaskFilter: CaseIterable {
    case all, pending, inProgress, completed, overdue, today, upcoming
}

enum TaskSort: CaseIterable {
    case dueDate, priority, title, createdDate, status
}

enum TaskViewMode: CaseIterable {
    case list, kanban
    
    var displayName: String {
        switch self {
        case .list: return "List"
        case .kanban: return "Kanban"
        }
    }
    
    var persianName: String {
        switch self {
        case .list: return "لیست"
        case .kanban: return "کانبان"
        }
    }
    
    var icon: String {
        switch self {
        case .list: return "list.bullet"
        case .kanban: return "rectangle.grid.2x2"
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LocalizationManager.shared)
        .environmentObject(ThemeManager.shared)
        .modelContainer(for: [Task.self, AppSettings.self], inMemory: true)
}
