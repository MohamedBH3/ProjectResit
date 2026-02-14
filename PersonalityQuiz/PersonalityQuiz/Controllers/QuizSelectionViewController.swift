import UIKit

/// Screen that shows quiz categories and allows selection.
final class QuizSelectionViewController: UIViewController {

    // MARK: - IBOutlets

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

    private var selectedQuizIndex: Int?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        configureLabels()
        configureButtons()
        configureTableView()
        updateStartButtonState()
        wireButtonFeedback()
        
    }

    // MARK: - UI

    private func configureLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = UIColor(hex: "282D37")

        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "6A717B")
    }

    private func configureButtons() {
        startQuizButton.backgroundColor = UIColor(hex: "4D8AE0")
        startQuizButton.layer.borderColor = UIColor(hex: "4D8AE0").cgColor
        startQuizButton.layer.borderWidth = 1.5
        startQuizButton.layer.cornerRadius = 14
        startQuizButton.setTitleColor(UIColor(hex: "FEFEFE"), for: .normal)
        startQuizButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

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

        quizTableView.register(QuizCardCell.self,
                               forCellReuseIdentifier: QuizCardCell.reuseIdentifier)

        quizTableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
    }

    private func updateStartButtonState() {
        let enabled = (selectedQuizIndex != nil)
        startQuizButton.isEnabled = enabled
        startQuizButton.alpha = enabled ? 1.0 : 0.5
    }
    // MARK: - Button press feedback wiring

    private func wireButtonFeedback() {
        // Touch down = press in
        startQuizButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        historyButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)

        // Touch up/cancel = release
        let releaseEvents: UIControl.Event = [.touchUpInside, .touchUpOutside, .touchCancel]
        startQuizButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: releaseEvents)
        historyButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: releaseEvents)
    }

    @objc private func buttonTouchDown(_ sender: UIButton) {
        sender.animatePressedDown()
    }

    @objc private func buttonTouchUp(_ sender: UIButton) {
        sender.animateReleased()
    }

    // MARK: - Actions

    @IBAction private func startQuizTapped(_ sender: UIButton) {
        // Color feedback only (press animation is handled by touchDown/touchUp targets).
        sender.applyColorFeedback(darkerHex: "3F7DDA")

        guard selectedQuizIndex != nil else { return }
        performSegue(withIdentifier: "showQuiz", sender: nil)
    }

    @IBAction private func historyTapped(_ sender: UIButton) {
        sender.applyColorFeedback(darkerHex: "ECF2FD")
        performSegue(withIdentifier: "showHistory", sender: nil)
    }

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

        cell.configure(with: quizzes[indexPath.row])

        let isSelected = (indexPath.row == selectedQuizIndex)
        cell.setSelectedAppearance(isSelected, animated: false)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Animate the tapped card (tap feedback).
        if let tappedCell = tableView.cellForRow(at: indexPath) as? QuizCardCell {
            tappedCell.animateTapFeedback()
        }

        // Turn off the previously selected card UI (if any).
        if let previousIndex = selectedQuizIndex,
           previousIndex != indexPath.row,
           let previousCell = tableView.cellForRow(at: IndexPath(row: previousIndex, section: 0)) as? QuizCardCell {
            previousCell.setSelectedAppearance(false, animated: true)
        }

        // Save new selection and update UI for tapped card.
        selectedQuizIndex = indexPath.row
        updateStartButtonState()

        if let tappedCell = tableView.cellForRow(at: indexPath) as? QuizCardCell {
            tappedCell.setSelectedAppearance(true, animated: true)
        }
    
    }
}
