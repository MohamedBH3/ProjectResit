import UIKit
import UserNotifications

final class TodoListViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!

    private var allTodos: [Todo] = []
    private var filteredTodos: [Todo] = []

    private let store = TodoStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureSearchBarAppearance()
        configureSegmentedControlAppearance()
        configureTableView()

        requestNotificationAuthorization()

        store.load()
        reloadFromStore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFromStore()
    }

    // ✅ FIX: prevents the top border from looking clipped after layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let tf = searchBar.searchTextField
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor
    }

    // MARK: - UI

    private func configureUI() {
        title = "To-Do List"
        view.backgroundColor = .systemGroupedBackground

        searchBar.delegate = self

        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
    }
    private func configureSearchBarAppearance() {
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .minimal

        let tf = searchBar.searchTextField
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.layer.masksToBounds = false
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor

        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.textColor = .label

        tf.attributedPlaceholder = NSAttributedString(
            string: "Search tasks",
            attributes: [.foregroundColor: UIColor.systemGray]
        )

      
        tf.clipsToBounds = false
        
    }

    private func configureSegmentedControlAppearance() {
        // White pill background like Figma
        categorySegmentedControl.backgroundColor = .white
        categorySegmentedControl.selectedSegmentTintColor = .systemBlue

        categorySegmentedControl.layer.cornerRadius = 8
        categorySegmentedControl.layer.masksToBounds = true
        categorySegmentedControl.layer.borderWidth = 1
        categorySegmentedControl.layer.borderColor = UIColor.systemGray4.cgColor

        categorySegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.white,
             .font: UIFont.systemFont(ofSize: 13, weight: .semibold)],
            for: .selected
        )

        categorySegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.label,
             .font: UIFont.systemFont(ofSize: 13, weight: .semibold)],
            for: .normal
        )
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96

        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)

        // Ensures your programmatic card cell is always the one used.
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
    }

    // MARK: - Data

    private func reloadFromStore() {
        allTodos = store.todos
        applyFilters()
        tableView.reloadData()
    }

    @objc private func filterChanged() {
        applyFilters()
        tableView.reloadData()
    }

    @IBAction private func addButtonTapped(_ sender: UIBarButtonItem) {
        presentEdit(todo: nil)
    }

    private func presentEdit(todo: Todo?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard
            let nav = storyboard.instantiateViewController(withIdentifier: "TodoEditNav") as? UINavigationController,
            let editVC = nav.viewControllers.first as? TodoEditViewController
        else {
            assertionFailure("Storyboard IDs not set: TodoEditNav / TodoEditViewController")
            return
        }

        editVC.todoToEdit = todo
        editVC.delegate = self
        present(nav, animated: true)
    }

    private func applyFilters() {
        let query = (searchBar.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        var result = allTodos

        switch categorySegmentedControl.selectedSegmentIndex {
        case 1:
            result = result.filter { $0.category == .work && !$0.isCompleted }
        case 2:
            result = result.filter { $0.category == .personal && !$0.isCompleted }
        case 3:
            result = result.filter { $0.isCompleted }
        default:
            break
        }

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
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    // MARK: - Completion Toggle

    private func toggleCompletion(for todo: Todo) {
        var updated = todo
        updated.isCompleted.toggle()

        if updated.isCompleted {
            updated.reminderEnabled = false
            NotificationScheduler.cancelNotification(for: updated.id)
        }

        store.update(updated)
        reloadFromStore()
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTodos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = filteredTodos[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }

        let subtitle = subtitleForMainList(todo: todo)
        let subtitleColor = subtitleColorForMainList(todo: todo)

        cell.configure(
            title: todo.title,
            subtitle: subtitle,
            subtitleColor: subtitleColor,
            isCompleted: todo.isCompleted
        )

        // ✅ Tap circle toggles completion (without opening edit).
        cell.onToggleCompletion = { [weak self] in
            self?.toggleCompletion(for: todo)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tapping the row edits; tapping the circle toggles completion.
        presentEdit(todo: filteredTodos[indexPath.row])
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let todo = filteredTodos[indexPath.row]

        let completeTitle = todo.isCompleted ? "Uncomplete" : "Complete"
        let complete = UIContextualAction(style: .normal, title: completeTitle) { [weak self] _, _, done in
            self?.toggleCompletion(for: todo)
            done(true)
        }

        complete.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [complete])
    }
}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilters()
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - TodoEditViewControllerDelegate

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

        if due < Date() { return .systemRed }

        let soonThreshold = Date().addingTimeInterval(24 * 60 * 60)
        if due <= soonThreshold { return .systemBlue }

        return .secondaryLabel
    }

    static let mainListDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d • h:mm a"
        return df
    }()
}
