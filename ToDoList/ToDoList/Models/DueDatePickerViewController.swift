import UIKit

/// A lightweight sheet that hosts a wheel-style date picker.
/// Sends live updates on every wheel change + sends final value on Done.
final class DueDatePickerViewController: UIViewController {

    private let picker = UIDatePicker()

    private let onChange: (Date) -> Void
    private let onDone: (Date) -> Void

    private let doneButton = UIButton(type: .system)

    init(initialDate: Date,
         onChange: @escaping (Date) -> Void,
         onDone: @escaping (Date) -> Void) {
        self.onChange = onChange
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

        // Live update whenever wheels change.
        picker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)

        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(doneButton)
        view.addSubview(picker)

        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            picker.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 6),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // Height tuned for wheels; keeps the sheet compact.
            picker.heightAnchor.constraint(equalToConstant: 216),

            picker.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    @objc private func pickerChanged() {
        onChange(picker.date)
    }

    @objc private func doneTapped() {
        // One last “commit” in case user taps Done quickly.
        onChange(picker.date)
        onDone(picker.date)
        dismiss(animated: true)
    }
}
