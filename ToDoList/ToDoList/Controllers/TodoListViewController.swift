import UIKit
import UserNotifications

final class TodoListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    private var allTodos: [Todo] = []
    private var filteredTodos: [Todo] = []

    private let store = TodoStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "To-Do List"
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemGroupedBackground

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = 86
        tableView.separatorStyle = .none

        categorySegmentedControl.selectedSegmentIndex = 0 // All
        categorySegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)

        requestNotificationAuthorization()

        store.load()
        reloadFromStore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFromStore()
    }

    private func reloadFromStore() {
        allTodos = store.todos
        applyFilters()
        tableView.reloadData()
    }

    @objc private func filterChanged() {
        applyFilters()
        tableView.reloadData()
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentEdit(todo: nil)
    }

    private func presentEdit(todo: Todo?) {
        // If you prefer segues, you can ignore this and call performSegue.
        // This code uses storyboard IDs for a clean setup.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard
            let nav = storyboard.instantiateViewController(withIdentifier: "TodoEditNav") as? UINavigationController,
            let editVC = nav.viewControllers.first as? TodoEditViewController
        else {
            assertionFailure("Storyboard IDs not set: TodoEditNav and TodoEditViewController")
            return
        }

        editVC.todoToEdit = todo
        editVC.delegate = self
        present(nav, animated: true)
    }

    private func applyFilters() {
        let query = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        var result = allTodos

        // Segment filter
        switch categorySegmentedControl.selectedSegmentIndex {
        case 1:
            result = result.filter { $0.category == .work && !$0.isCompleted }
        case 2:
            result = result.filter { $0.category == .personal && !$0.isCompleted }
        case 3:
            result = result.filter { $0.isCompleted }
        default:
            // All: show everything (both completed and not completed)
            break
        }

        // Search filter
        if !query.isEmpty {
            result = result.filter { todo in
                todo.title.lowercased().contains(query) ||
                todo.notes.lowercased().contains(query)
            }
        }

        filteredTodos = result
    }

    // MARK: - Notifications

    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
}

// MARK: - TableView

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTodos.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let todo = filteredTodos[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }

        // Title
        cell.textLabel?.text = todo.title

        // Circle vs checkmark-circle for completed
        let iconName = todo.isCompleted ? "checkmark.circle.fill" : "circle"
        cell.imageView?.image = UIImage(systemName: iconName)

        // Subtitle: Category • date • time (no year on main list)
        cell.detailTextLabel?.text = subtitleForMainList(todo: todo)
        cell.detailTextLabel?.textColor = subtitleColorForMainList(todo: todo)

        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = filteredTodos[indexPath.row]
        presentEdit(todo: todo)
    }

    // Swipe actions (optional but useful)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let todo = filteredTodos[indexPath.row]

        let completeTitle = todo.isCompleted ? "Uncomplete" : "Complete"
        let complete = UIContextualAction(style: .normal, title: completeTitle) { [weak self] _, _, done in
            guard let self else { return }
            var updated = todo
            updated.isCompleted.toggle()

            // If completed, turn off reminder and cancel pending notification.
            if updated.isCompleted {
                updated.reminderEnabled = false
                NotificationScheduler.cancelNotification(for: updated.id)
            }

            self.store.update(updated)
            self.reloadFromStore()
            done(true)
        }
        complete.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [complete])
    }
}

// MARK: - Search

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilters()
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Edit Delegate

extension TodoListViewController: TodoEditViewControllerDelegate {
    func todoEditViewControllerDidSave(todo: Todo) {
        if store.todos.contains(where: { $0.id == todo.id }) {
            store.update(todo)
        } else {
            store.add(todo)
        }
        reloadFromStore()
    }
}

// MARK: - Formatting helpers

private extension TodoListViewController {

    func subtitleForMainList(todo: Todo) -> String {
        var parts: [String] = [todo.category.rawValue]

        if let dueDate = todo.dueDate {
            parts.append(Self.mainListDateFormatter.string(from: dueDate))
        }

        return parts.joined(separator: " • ")
    }

    func subtitleColorForMainList(todo: Todo) -> UIColor {
        guard !todo.isCompleted, let due = todo.dueDate else {
            return .secondaryLabel
        }

        if due < Date() {
            return .systemRed // overdue
        }

        let soonThreshold = Date().addingTimeInterval(24 * 60 * 60)
        if due <= soonThreshold {
            return .systemBlue // due soon
        }

        return .secondaryLabel
    }

    static let mainListDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d • h:mm a" // no year (Figma-like)
        return df
    }()
}
