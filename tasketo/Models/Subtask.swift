import Foundation
import SwiftData

@Model
public final class Subtask {
    public var id: UUID
    var title: String
    var isCompleted: Bool
    var createdDate: Date
    var completedDate: Date?
    
    public init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.createdDate = Date()
    }
}
