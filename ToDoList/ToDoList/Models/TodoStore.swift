import Foundation

final class TodoStore {

    static let shared = TodoStore()

    private(set) var todos: [Todo] = []

    private init() {}

    // MARK: - Persistence

    private var fileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent("todos.json")
    }

    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            todos = try JSONDecoder().decode([Todo].self, from: data)
        } catch {
            // If first launch or file missing/corrupt, start with a small sample set.
            todos = [
                Todo(title: "Submit Assignment", notes: "", category: .work, isCompleted: false,
                     dueDate: Calendar.current.date(byAdding: .hour, value: -2, to: Date()),
                     reminderEnabled: false),
                Todo(title: "Finish UI Design", notes: "", category: .personal, isCompleted: false,
                     dueDate: Calendar.current.date(byAdding: .hour, value: 5, to: Date()),
                     reminderEnabled: false),
                Todo(title: "Buy Groceries", notes: "", category: .personal, isCompleted: false,
                     dueDate: nil,
                     reminderEnabled: false),
                Todo(title: "Workout", notes: "", category: .work, isCompleted: true,
                     dueDate: nil,
                     reminderEnabled: false)
            ]
            save()
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Failed to save todos: \(error)")
        }
    }

    // MARK: - CRUD

    func add(_ todo: Todo) {
        todos.insert(todo, at: 0)
        save()
    }

    func update(_ todo: Todo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index] = todo
        save()
    }

    func delete(id: UUID) {
        todos.removeAll { $0.id == id }
        save()
    }
}
