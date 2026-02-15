import Foundation

enum TodoCategory: String, Codable, CaseIterable {
    case work = "Work"
    case personal = "Personal"
}

struct Todo: Codable, Equatable, Identifiable {
    let id: UUID
    var title: String
    var notes: String
    var category: TodoCategory
    var isCompleted: Bool

    /// If nil, the task has no due date.
    var dueDate: Date?

    /// If true, schedule a notification at `dueDate`.
    var reminderEnabled: Bool

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        category: TodoCategory = .work,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        reminderEnabled: Bool = false
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.category = category
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.reminderEnabled = reminderEnabled
    }
}
