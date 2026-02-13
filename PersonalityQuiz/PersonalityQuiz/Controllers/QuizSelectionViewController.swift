import UIKit

final class QuizSelectionViewController: UIViewController {

    // MARK: - IBOutlets (Storyboard)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var quizTableView: UITableView!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
        // MARK: - Data

        // Quizzes shown on the first screen
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

        // Tracks the selected quiz row (nil means no selection)
        private var selectedQuizIndex: Int?

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            // Screen 1 is designed without a navigation bar
            navigationController?.setNavigationBarHidden(true, animated: false)

            // Apply Figma styling
            configureLabels()
            configureButtons()

            // TableView setup (data source, delegate, registration)
            configureTableView()

            // Start button should only be enabled after a quiz is selected
            updateStartButtonState()
        }

        // MARK: - UI State

        // Enables/disables Start Quiz based on whether a quiz is selected
        private func updateStartButtonState() {
            let hasSelection = (selectedQuizIndex != nil)
            startQuizButton.isEnabled = hasSelection
            startQuizButton.alpha = hasSelection ? 1.0 : 0.5
        }

        // MARK: - UI Styling

        private func configureLabels() {
            titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
            titleLabel.textColor = UIColor(hex: "282D37")

            subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            subtitleLabel.textColor = UIColor(hex: "6A717B")
        }

        private func configureButtons() {
            // Start Quiz button styling (Figma)
            startQuizButton.backgroundColor = UIColor(hex: "4D8AE0")
            startQuizButton.layer.borderColor = UIColor(hex: "4D8AE0").cgColor
            startQuizButton.layer.borderWidth = 1.5
            startQuizButton.layer.cornerRadius = 14
            startQuizButton.setTitleColor(UIColor(hex: "FEFEFE"), for: .normal)
            startQuizButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

            // History button styling (Figma)
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

            // Using a programmatic cell for the quiz cards
            quizTableView.register(QuizCardCell.self,
                                   forCellReuseIdentifier: QuizCardCell.reuseIdentifier)

            // Adds vertical spacing around the list
            quizTableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        }

        // MARK: - Actions

        @IBAction private func startQuizTapped(_ sender: UIButton) {
            // Prevent navigating if nothing is selected (extra safety)
            guard selectedQuizIndex != nil else { return }
            performSegue(withIdentifier: "showQuiz", sender: nil)
        }

        @IBAction private func historyTapped(_ sender: UIButton) {
            performSegue(withIdentifier: "showHistory", sender: nil)
        }

        // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Pass the selected quiz into the questions screen
            guard segue.identifier == "showQuiz",
                  let selectedQuizIndex,
                  let destination = segue.destination as? QuestionViewController else {
                return
            }

            destination.quizCategory = quizzes[selectedQuizIndex]
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

            // Configure the cell with the quiz info
            cell.configure(with: quizzes[indexPath.row])
            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            110
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Save selection and enable Start Quiz
            selectedQuizIndex = indexPath.row
            updateStartButtonState()
        }
    }
