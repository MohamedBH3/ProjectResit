import UIKit

protocol TodoEditViewControllerDelegate: AnyObject {
    func todoEditViewControllerDidSave(todo: Todo)
}

final class TodoEditViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var dueDateSwitch: UISwitch!
    @IBOutlet private weak var dueDateButton: UIButton!
    @IBOutlet private weak var reminderSwitch: UISwitch!
    @IBOutlet private weak var reminderDescriptionLabel: UILabel!

    @IBOutlet private weak var titleNotesCard: UIView?
    @IBOutlet private weak var categoryCard: UIView?
    @IBOutlet private weak var dueDateCard: UIView?
    @IBOutlet private weak var reminderCard: UIView?

    weak var delegate: TodoEditViewControllerDelegate?

    var todoToEdit: Todo?
    private var workingTodo: Todo = Todo(title: "")

    private let notesPlaceholderText = "Notes"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        loadInitialData()
        refreshDueDateUI()
        refreshReminderUI()
    }

    // MARK: - UI

    private func configureUI() {
        view.backgroundColor = .systemGroupedBackground

        dueDateButton.contentHorizontalAlignment = .left
        dueDateButton.contentEdgeInsets = .zero
        dueDateButton.titleEdgeInsets = .zero

        // Make disabled “Select a date” look consistent and readable.
        dueDateButton.setTitleColor(.systemBlue, for: .normal)
        dueDateButton.setTitleColor(.secondaryLabel, for: .disabled)
        dueDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        notesTextView.delegate = self
        notesTextView.layer.cornerRadius = 8
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.systemGray5.cgColor

        titleTextField.addTarget(self, action: #selector(titleChanged), for: .editingChanged)

        dueDateSwitch.addTarget(self, action: #selector(dueDateSwitchChanged), for: .valueChanged)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchChanged), for: .valueChanged)

        configureSegmentedControlAppearance()
        styleCardsIfPresent()
        addCardSeparatorsIfPresent()

        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
            [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)],
            for: .selected
        )

        categorySegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)],
            for: .normal
        )
    }

    private func styleCardsIfPresent() {
        let cards: [UIView?] = [titleNotesCard, categoryCard, dueDateCard, reminderCard]

        cards.forEach { card in
            guard let card else { return }
            card.backgroundColor = .white
            card.layer.cornerRadius = 12
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor.systemGray5.cgColor

            // Subtle shadow like your current screenshots
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.06
            card.layer.shadowRadius = 8
            card.layer.shadowOffset = CGSize(width: 0, height: 2)

            card.clipsToBounds = false
        }
    }

    // ✅ FIX: separators placed correctly inside cards (like Figma)
    private func addCardSeparatorsIfPresent() {
        let hairline = 1.0 / UIScreen.main.scale

        func addSeparator(in card: UIView?, above belowView: UIView?, verticalGap: CGFloat, id: String) {
            guard let card, let belowView else { return }

            // Prevent duplicates
            if card.subviews.contains(where: { $0.accessibilityIdentifier == id }) { return }

            let line = UIView()
            line.accessibilityIdentifier = id
            line.backgroundColor = UIColor.systemGray5
            line.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(line)

            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: card.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: card.trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: hairline),
                line.bottomAnchor.constraint(equalTo: belowView.topAnchor, constant: -verticalGap)
            ])
        }

        // Title/Notes: separator above notesTextView
        addSeparator(in: titleNotesCard, above: notesTextView, verticalGap: 8, id: "sep_title_notes")

        // Due Date: separator above dueDateButton (value row)
        addSeparator(in: dueDateCard, above: dueDateButton, verticalGap: 10, id: "sep_due_date")

        // Reminder: separator above reminderDescriptionLabel (description row)
        addSeparator(in: reminderCard, above: reminderDescriptionLabel, verticalGap: 10, id: "sep_reminder")
    }

    // MARK: - Data

    private func loadInitialData() {
        if let existing = todoToEdit {
            workingTodo = existing
            title = "Edit Task"
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            workingTodo = Todo(title: "", notes: "", category: .work, isCompleted: false, dueDate: nil, reminderEnabled: false)
            title = "Add Task"

            // Disable share in add mode if present.
            if let rightItems = navigationItem.rightBarButtonItems, rightItems.count >= 2 {
                rightItems.forEach { item in
                    if item.image != nil { item.isEnabled = false }
                }
            }
        }

        titleTextField.text = workingTodo.title

        if workingTodo.notes.isEmpty {
            notesTextView.text = notesPlaceholderText
            notesTextView.textColor = .secondaryLabel
        } else {
            notesTextView.text = workingTodo.notes
            notesTextView.textColor = .label
        }

        categorySegmentedControl.selectedSegmentIndex = (workingTodo.category == .work) ? 0 : 1

        dueDateSwitch.isOn = (workingTodo.dueDate != nil)
        reminderSwitch.isOn = workingTodo.reminderEnabled
    }

    // MARK: - Actions

    @IBAction private func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction private func saveTapped(_ sender: UIBarButtonItem) {
        let titleText = (titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !titleText.isEmpty else {
            showAlert(title: "Missing Title", message: "Please enter a title for the task.")
            return
        }

        workingTodo.title = titleText

        let notesText = notesTextView.text ?? ""
        workingTodo.notes = (notesText == notesPlaceholderText) ? "" : notesText

        workingTodo.category = (categorySegmentedControl.selectedSegmentIndex == 0) ? .work : .personal

        if !dueDateSwitch.isOn {
            workingTodo.dueDate = nil
            workingTodo.reminderEnabled = false
        }

        NotificationScheduler.scheduleNotification(for: workingTodo)

        delegate?.todoEditViewControllerDidSave(todo: workingTodo)
        dismiss(animated: true)
    }

    @IBAction private func shareTapped(_ sender: UIBarButtonItem) {
        let text = shareText(for: workingTodo)
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @IBAction private func dueDateButtonTapped(_ sender: UIButton) {
        guard dueDateSwitch.isOn else { return }

        let initialDate = workingTodo.dueDate ?? Date()

        let pickerVC = DueDatePickerViewController(
            initialDate: initialDate,
            onChange: { [weak self] date in
                guard let self else { return }
                self.workingTodo.dueDate = date
                self.refreshDueDateUI()   // ✅ updates immediately while scrolling
            },
            onDone: { [weak self] date in
                guard let self else { return }
                self.dueDateSwitch.setOn(true, animated: true)
                self.workingTodo.dueDate = date
                self.refreshDueDateUI()

                if self.workingTodo.reminderEnabled {
                    NotificationScheduler.scheduleNotification(for: self.workingTodo)
                }
            }
        )

        pickerVC.modalPresentationStyle = .pageSheet
        if let sheet = pickerVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in 320 })]
            sheet.prefersGrabberVisible = true
        }

        present(pickerVC, animated: true)
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

        if let due = workingTodo.dueDate, dueDateSwitch.isOn {
            dueDateButton.setTitle(Self.editDateFormatter.string(from: due), for: .normal)
        } else {
            dueDateButton.setTitle("Select a date", for: .normal)
        }
    }

    private func refreshReminderUI() {
        let canEnableReminder = dueDateSwitch.isOn && (workingTodo.dueDate != nil)
        reminderSwitch.isEnabled = canEnableReminder

        // Keep both lines consistent when disabled.
        reminderDescriptionLabel.textColor = .secondaryLabel
        reminderDescriptionLabel.alpha = 1.0
    }

    // MARK: - Misc

    @objc private func titleChanged() {
        // Validation happens on Save.
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
        df.dateFormat = "MMMM d, yyyy • h:mm a"
        return df
    }()
}

// MARK: - UITextViewDelegate (Notes placeholder)

extension TodoEditViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView === notesTextView else { return }
        if textView.text == notesPlaceholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView === notesTextView else { return }

        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            textView.text = notesPlaceholderText
            textView.textColor = .secondaryLabel
        }
    }
}
