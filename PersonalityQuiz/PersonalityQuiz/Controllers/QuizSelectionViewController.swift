import UIKit

final class QuizSelectionViewController: UIViewController {

    // MARK: - IBOutlets (Storyboard)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var quizTableView: UITableView!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!

        // MARK: - Data

        private let quizzes: [QuizCategory] = [
            QuizCategory(title: "Food Quiz",
                         subtitle: "Answer fun questions about\nyour food preferences.",
                         iconName: "foodIcon"),
            QuizCategory(title: "Animal Quiz",
                         subtitle: "Discover which animal matches\nyour personality!",
                         iconName: "animalIcon"),
            QuizCategory(title: "Music Quiz",
                         subtitle: "Find out your music personality\nwith fun questions!",
                         iconName: "musicIcon")
        ]

        // Tracks the currently selected category row.
        // `nil` means nothing selected yet.
        private var selectedQuizIndex: Int?

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            navigationController?.setNavigationBarHidden(true, animated: false)

            configureLabels()
            configureButtons()
            configureTableView()

            updateStartButtonState()
        }
    // MARK: - Button feedback handlers

    @objc private func buttonTapped(_ sender: UIButton) {

        // Apply scale animation.
        sender.applyPressFeedback()

        // Apply optional color feedback depending on button.
        if sender == startQuizButton {
            sender.applyColorFeedback(darkerHex: "3F7DDA")
        } else if sender == historyButton {
            sender.applyColorFeedback(darkerHex: "ECF2FD")
        }
    }
    

        // MARK: - UI Configuration

        private func configureLabels() {
            titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
            titleLabel.textColor = UIColor(hex: "282D37")

            subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            subtitleLabel.textColor = UIColor(hex: "6A717B")
        }

        private func configureButtons() {
            // Start Quiz button styling
            startQuizButton.backgroundColor = UIColor(hex: "4D8AE0")
            startQuizButton.layer.borderColor = UIColor(hex: "4D8AE0").cgColor
            startQuizButton.layer.borderWidth = 1.5
            startQuizButton.layer.cornerRadius = 14
            startQuizButton.setTitleColor(UIColor(hex: "FEFEFE"), for: .normal)
            startQuizButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

            // History button styling
            historyButton.backgroundColor = UIColor(hex: "FDFDFE")
            historyButton.layer.borderColor = UIColor(hex: "ECECF1").cgColor
            historyButton.layer.borderWidth = 1.5
            historyButton.layer.cornerRadius = 14
            historyButton.setTitleColor(UIColor(hex: "3985E3"), for: .normal)
            historyButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            
        }

        private func configureTableView() {
            quizTableView.backgroundColor = .clear
            quizTableView.separatorStyle = .none
            quizTableView.showsVerticalScrollIndicator = false

            quizTableView.dataSource = self
            quizTableView.delegate = self

            // Important: QuizCardCell here is programmatic.
            // If you have a storyboard prototype cell instead, remove this register
            // and set the prototype cell reuse identifier + class.
            quizTableView.register(QuizCardCell.self,
                                   forCellReuseIdentifier: QuizCardCell.reuseIdentifier)

            quizTableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        }

        // Disables Start until a quiz is selected (matches expected UX).
        private func updateStartButtonState() {
            let enabled = (selectedQuizIndex != nil)
            startQuizButton.isEnabled = enabled
            startQuizButton.alpha = enabled ? 1.0 : 0.5
        }

        // MARK: - Actions

        @IBAction private func startQuizTapped(_ sender: UIButton) {
            // Button feedback (press animation + slightly darker blue)
            sender.applyPressFeedback()
            sender.applyColorFeedback(darkerHex: "3F7DDA")

            // Require selection before navigating.
            guard selectedQuizIndex != nil else { return }

            performSegue(withIdentifier: "showQuiz", sender: nil)
        }

        @IBAction private func historyTapped(_ sender: UIButton) {
            // Button feedback (press animation + subtle background tint)
            sender.applyPressFeedback()
            sender.applyColorFeedback(darkerHex: "ECF2FD")

            performSegue(withIdentifier: "showHistory", sender: nil)
        }

        // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showQuiz",
               let index = selectedQuizIndex,
               let destination = segue.destination as? QuestionViewController {
                destination.quizCategory = quizzes[index]
            }
        }
    }



    // MARK: - UITableViewDataSource / UITableViewDelegate

    extension QuizSelectionViewController: UITableViewDataSource, UITableViewDelegate {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            quizzes.count
        }

        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: QuizCardCell.reuseIdentifier,
                for: indexPath
            ) as? QuizCardCell else {
                return UITableViewCell()
            }

            // Provide content for this row.
            cell.configure(with: quizzes[indexPath.row])

            // Update the cell’s selection UI to match the current selectedQuizIndex.
            let isSelected = (indexPath.row == selectedQuizIndex)
            cell.setSelectedAppearance(isSelected, animated: false)

            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            110
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Update selection state.
            selectedQuizIndex = indexPath.row
            updateStartButtonState()
            if let cell = tableView.cellForRow(at: indexPath) as? QuizCardCell {
                cell.animatePress()
            }

            // Reload to refresh checkmarks/chevrons.
            tableView.reloadData()
        }
    }
