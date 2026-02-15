import UIKit

protocol TodoEditViewControllerDelegate: AnyObject {
    func todoEditViewControllerDidSave(todo: Todo)
}

final class TodoEditViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var reminderDescriptionLabel: UILabel!

    weak var delegate: TodoEditViewControllerDelegate?

    /// nil = Add mode, non-nil = Edit mode
    var todoToEdit: Todo?

    private var workingTodo: Todo = Todo(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        loadInitialData()
        refreshDueDateUI()
        refreshReminderUI()
    }

    private func configureUI() {
        // Button alignment to match Figma (left aligned blue text)
        dueDateButton.contentHorizontalAlignment = .left
        dueDateButton.contentEdgeInsets = .zero
        dueDateButton.titleEdgeInsets = .zero

        notesTextView.layer.cornerRadius = 8
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.systemGray5.cgColor

        titleTextField.addTarget(self, action: #selector(titleChanged), for: .editingChanged)

        dueDateSwitch.addTarget(self, action: #selector(dueDateSwitchChanged), for: .valueChanged)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchChanged), for: .valueChanged)

        // Tap outside to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func loadInitialData() {
        if let existing = todoToEdit {
            workingTodo = existing
            title = "Edit Task"
            navigationItem.rightBarButtonItem?.isEnabled = true
            // Share is visible in edit mode
        } else {
            workingTodo = Todo(title: "", notes: "", category: .work, isCompleted: false, dueDate: nil, reminderEnabled: false)
            title = "Add Task"
            // Hide share in add mode (assuming share button is the last right item)
            if let rightItems = navigationItem.rightBarButtonItems, rightItems.count >= 2 {
                // Usually [Save, Share] or [Share, Save] depending on storyboard.
                // Easiest: just disable share if present.
                rightItems.forEach { item in
                    if item.image != nil { item.isEnabled = false }
                }
            }
        }

        titleTextField.text = workingTodo.title
        notesTextView.text = workingTodo.notes.isEmpty ? "Notes" : workingTodo.notes
        notesTextView.textColor = workingTodo.notes.isEmpty ? .secondaryLabel : .label

        categorySegmentedControl.selectedSegmentIndex = (workingTodo.category == .work) ? 0 : 1

        dueDateSwitch.isOn = (workingTodo.dueDate != nil)
        reminderSwitch.isOn = workingTodo.reminderEnabled
    }

    // MARK: - Actions

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let titleText = (titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !titleText.isEmpty else {
            showAlert(title: "Missing Title", message: "Please enter a title for the task.")
            return
        }

        workingTodo.title = titleText

        // Notes placeholder handling
        let notesText = notesTextView.text ?? ""
        workingTodo.notes = (notesText == "Notes") ? "" : notesText

        // Category
        workingTodo.category = (categorySegmentedControl.selectedSegmentIndex == 0) ? .work : .personal

        // Due date on/off
        if !dueDateSwitch.isOn {
            workingTodo.dueDate = nil
            workingTodo.reminderEnabled = false
        }

        // Reminder scheduling
        NotificationScheduler.scheduleNotification(for: workingTodo)

        delegate?.todoEditViewControllerDidSave(todo: workingTodo)
        dismiss(animated: true)
    }

    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        let text = shareText(for: workingTodo)
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @IBAction func dueDateButtonTapped(_ sender: UIButton) {
        guard dueDateSwitch.isOn else { return }

        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        picker.date = workingTodo.dueDate ?? Date()

        let alert = UIAlertController(title: "Select Due Date", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(picker)

        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 16),
            picker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -16),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 48),
            picker.heightAnchor.constraint(equalToConstant: 200)
        ])

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.workingTodo.dueDate = picker.date
            self.refreshDueDateUI()

            // If reminder is on, reschedule to new date
            if self.workingTodo.reminderEnabled {
                NotificationScheduler.scheduleNotification(for: self.workingTodo)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // iPad safety
        if let popover = alert.popoverPresentationController {
            popover.sourceView = dueDateButton
            popover.sourceRect = dueDateButton.bounds
        }

        present(alert, animated: true)
    }

    // MARK: - UI Updates

    @objc private func dueDateSwitchChanged() {
        if dueDateSwitch.isOn {
            if workingTodo.dueDate == nil {
                workingTodo.dueDate = Date()
            }
        } else {
            workingTodo.dueDate = nil
            workingTodo.reminderEnabled = false
            reminderSwitch.setOn(false, animated: true)
            NotificationScheduler.cancelNotification(for: workingTodo.id)
        }
        refreshDueDateUI()
        refreshReminderUI()
    }

    @objc private func reminderSwitchChanged() {
        if reminderSwitch.isOn {
            guard dueDateSwitch.isOn, workingTodo.dueDate != nil else {
                reminderSwitch.setOn(false, animated: true)
                showAlert(title: "Due Date Required", message: "Turn on Due Date to enable reminders.")
                return
            }
            workingTodo.reminderEnabled = true
            NotificationScheduler.scheduleNotification(for: workingTodo)
        } else {
            workingTodo.reminderEnabled = false
            NotificationScheduler.cancelNotification(for: workingTodo.id)
        }
        refreshReminderUI()
    }

    private func refreshDueDateUI() {
        let hasDueDate = (workingTodo.dueDate != nil) && dueDateSwitch.isOn
        dueDateButton.isEnabled = hasDueDate
        dueDateButton.alpha = hasDueDate ? 1.0 : 0.35

        if let due = workingTodo.dueDate, dueDateSwitch.isOn {
            dueDateButton.setTitle(Self.editDateFormatter.string(from: due), for: .normal)
        } else {
            dueDateButton.setTitle("Select a date", for: .normal)
        }
    }

    private func refreshReminderUI() {
        let canEnableReminder = dueDateSwitch.isOn && (workingTodo.dueDate != nil)
        reminderSwitch.isEnabled = canEnableReminder
        reminderDescriptionLabel.alpha = canEnableReminder ? 1.0 : 0.45
    }

    // MARK: - Notes placeholder behavior

    @objc private func titleChanged() {
        // Nothing special required; title validated on save.
    }

    @objc private func endEditingTap() {
        view.endEditing(true)
    }

    // MARK: - Helpers

    private func shareText(for todo: Todo) -> String {
        var lines: [String] = []
        lines.append("To-Do: \(todo.title)")
        lines.append("Category: \(todo.category.rawValue)")

        if let due = todo.dueDate {
            lines.append("Due: \(Self.editDateFormatter.string(from: due))")
        } else {
            lines.append("Due: None")
        }

        if !todo.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            lines.append("Notes: \(todo.notes)")
        }

        return lines.joined(separator: "\n")
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    static let editDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM d, yyyy • h:mm a" // Edit screen includes year
        return df
    }()
}
