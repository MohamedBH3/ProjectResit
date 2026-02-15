import UIKit

/// A lightweight sheet that hosts a wheel-style date picker.
final class DueDatePickerViewController: UIViewController {

    private let picker = UIDatePicker()
    private let onDone: (Date) -> Void

    init(initialDate: Date, onDone: @escaping (Date) -> Void) {
        self.onDone = onDone
        super.init(nibName: nil, bundle: nil)
        picker.date = initialDate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        picker.translatesAutoresizingMaskIntoConstraints = false

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(doneButton)
        view.addSubview(picker)

        // Wheels are ~216pt tall; keep it tight.
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            picker.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 6),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.heightAnchor.constraint(equalToConstant: 216),

            // Keep a small bottom padding so it doesn’t feel cramped
            picker.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    @objc private func doneTapped() {
        onDone(picker.date)
        dismiss(animated: true)
    }
}
