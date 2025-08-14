# Tasketo - Task Manager App

A comprehensive task management application built with SwiftUI and SwiftData, featuring bilingual support (Persian/English), dual calendar systems (Gregorian/Shamsi), customizable themes, and offline-first architecture.

## Features

### 🌍 Multi-Language Support
- **English** and **Persian** language support
- Right-to-Left (RTL) layout for Persian
- Complete localization of all UI elements

### 📅 Dual Calendar System
- **Gregorian Calendar** (English)
- **Shamsi Calendar** (Persian)
- Automatic date conversion between calendars
- Localized date formatting

### 🎨 Customizable Themes
- **Light Mode**
- **Dark Mode**
- **System Mode** (follows device settings)
- **Customizable Colors**: 11 different color options for primary and accent colors

### 📱 Core Task Management
- Create, edit, and delete tasks
- Task priorities (Low, Medium, High, Urgent)
- Task statuses (Pending, In Progress, Completed, Cancelled)
- Due dates with calendar type selection
- Tags and notes support
- Subtasks with progress tracking
- Recurring tasks (Daily, Weekly, Monthly, Yearly)

### 🔍 Advanced Features
- **Search functionality** across titles, descriptions, and tags
- **Filtering** by status, due date, and priority
- **Sorting** by multiple criteria
- **Offline-first** architecture with local data storage
- **SwiftData** integration for persistent storage

### 🏗️ Architecture

```
tasketo/
├── Models/
│   ├── Task.swift              # Main task model with all properties
│   ├── Subtask.swift           # Subtask model for nested tasks
│   └── AppSettings.swift       # User preferences and app settings
├── Utils/
│   ├── CalendarHelper.swift    # Calendar conversion and formatting
│   ├── LocalizationManager.swift # Language management
│   └── ThemeManager.swift      # Theme and color management
├── Views/
│   ├── MainView.swift          # Main tab-based interface
│   └── Components/
│       ├── TaskRowView.swift   # Individual task display
│       ├── AddTaskView.swift   # Task creation form
│       └── SettingsView.swift  # App settings interface
└── tasketoApp.swift           # Main app entry point
```

## Data Models

### Task Model
- **id**: Unique identifier
- **title**: Task title
- **taskDescription**: Detailed description
- **priority**: TaskPriority enum (Low, Medium, High, Urgent)
- **status**: TaskStatus enum (Pending, In Progress, Completed, Cancelled)
- **dueDate**: Optional due date
- **createdDate**: Creation timestamp
- **completedDate**: Optional completion timestamp
- **calendarType**: CalendarType enum (Gregorian, Shamsi)
- **tags**: Array of string tags
- **isRecurring**: Boolean for recurring tasks
- **recurrencePattern**: RecurrencePattern enum (Daily, Weekly, Monthly, Yearly)
- **subtasks**: Array of Subtask objects
- **attachments**: Array of file paths/URLs
- **notes**: Additional notes

### AppSettings Model
- **language**: AppLanguage enum (English, Persian)
- **theme**: AppTheme enum (Light, Dark, System)
- **calendarType**: CalendarType enum
- **primaryColor**: String identifier for primary color
- **accentColor**: String identifier for accent color
- **isFirstLaunch**: Boolean for first-time setup
- **lastSyncDate**: Optional last sync timestamp

## Key Components

### LocalizationManager
- Manages current language selection
- Provides localized strings for all UI elements
- Handles RTL layout direction

### ThemeManager
- Manages app theme (Light/Dark/System)
- Handles customizable colors
- Provides color scheme for SwiftUI

### CalendarHelper
- Converts between Gregorian and Shamsi calendars
- Formats dates according to selected calendar and language
- Provides relative date strings

## Usage

### Creating a Task
1. Tap the "+" button in the main interface
2. Fill in task details (title, description, priority, etc.)
3. Set due date and calendar type if needed
4. Add tags and notes
5. Save the task

### Managing Tasks
- **Search**: Use the search bar to find tasks
- **Filter**: Use the filter menu to show specific task types
- **Sort**: Use the sort menu to organize tasks
- **Edit**: Tap on a task to edit its details
- **Delete**: Swipe left on a task to delete it

### Customizing the App
1. Tap the settings gear icon
2. Choose your preferred language
3. Select theme (Light/Dark/System)
4. Choose calendar type
5. Customize primary and accent colors

## Technical Details

### Dependencies
- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Persistent data storage
- **Foundation**: Core functionality and date handling

### Data Persistence
- Uses SwiftData for local storage
- Offline-first architecture
- Ready for future cloud sync integration

### Performance
- Efficient filtering and sorting
- Lazy loading of task lists
- Optimized for both English and Persian text rendering

## Future Enhancements

### Planned Features
- **Calendar View**: Visual calendar interface
- **Statistics**: Task completion analytics
- **Cloud Sync**: Django backend integration
- **Notifications**: Due date reminders
- **Attachments**: File and image support
- **Export/Import**: Data backup and restore
- **Collaboration**: Shared tasks and teams

### Backend Integration
- Django REST API for cloud sync
- User authentication and authorization
- Real-time collaboration features
- Cross-platform data synchronization

## Development

### Requirements
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Building
1. Clone the repository
2. Open `tasketo.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project

### Testing
- Test both English and Persian languages
- Verify RTL layout functionality
- Test all theme combinations
- Validate calendar conversions

## Contributing

This project is designed to be easily extensible. Key areas for contribution:
- Calendar view implementation
- Statistics and analytics
- Cloud sync integration
- Additional language support
- Enhanced UI/UX features

## License

This project is open source and available under the MIT License.
