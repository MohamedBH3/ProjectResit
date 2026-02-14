import UIKit

/// Handles presentation and logic of quiz questions.
/// Computes the final result and navigates to `ResultsViewController` at the end.
final class QuestionViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var questionNumberLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var instructionLabel: UILabel!
    @IBOutlet private weak var answersTableView: UITableView!

    @IBOutlet private weak var rangeSlider: UISlider!
    @IBOutlet private weak var leftRangeLabel: UILabel!
    @IBOutlet private weak var rightRangeLabel: UILabel!

    @IBOutlet private weak var nextButton: UIButton!

    // MARK: - Inputs

    /// Provided by `QuizSelectionViewController` during segue.
    var quizCategory: QuizCategory!

    // MARK: - State

    private var quiz: Quiz!
    private var currentQuestionIndex = 0

    private var selectedSingleIndex: Int?
    private var selectedMultipleIndexes = Set<Int>()

    /// Collected scoring IDs across the whole quiz (e.g., ["A", "B", "A", "D"]).
    private var collectedResultIDs: [String] = []

    private var secondsRemaining: Int = 15
    private var timer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
        buildQuizFromSelection()
        showCurrentQuestion()
        startTimer()
        wireButtonFeedback()
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - UI Setup

    private func configureUI() {
        view.backgroundColor = .systemBackground

        questionNumberLabel.textColor = UIColor(hex: "282D37")
        questionNumberLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .semibold)

        timerLabel.textColor = UIColor(hex: "4D8AE0")
        timerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        progressView.trackTintColor = UIColor(hex: "ECECF1")
        progressView.progressTintColor = UIColor(hex: "4D8AE0")

        questionLabel.textColor = UIColor(hex: "282D37")
        questionLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping

        instructionLabel.textColor = UIColor(hex: "6A717B")
        instructionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        instructionLabel.numberOfLines = 0

        questionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        instructionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        nextButton.backgroundColor = UIColor(hex: "4D8AE0")
        nextButton.layer.cornerRadius = 14
        nextButton.setTitleColor(UIColor(hex: "FEFEFE"), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    private func configureTableView() {
        answersTableView.backgroundColor = .clear
        answersTableView.separatorStyle = .none
        answersTableView.showsVerticalScrollIndicator = false

        answersTableView.dataSource = self
        answersTableView.delegate = self

        answersTableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
    }

    // MARK: - Quiz Construction

    private func buildQuizFromSelection() {
        let id = quizCategory.title.lowercased().replacingOccurrences(of: " ", with: "_")
        quiz = Quiz(
            id: id,
            title: quizCategory.title,
            questions: QuizFactory.makeQuestions(for: quizCategory.title)
        )
    }

    // MARK: - Button Feedback Wiring

    private func wireButtonFeedback() {
        nextButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        nextButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }

    @objc private func buttonTouchDown(_ sender: UIButton) {
        sender.animatePressedDown()
    }

    @objc private func buttonTouchUp(_ sender: UIButton) {
        sender.animateReleased()
    }

    // MARK: - Timer

    private func startTimer() {
        timer?.invalidate()

        secondsRemaining = 15
        updateTimerLabel()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.secondsRemaining -= 1
            self.updateTimerLabel()

            if self.secondsRemaining <= 0 {
                self.timer?.invalidate()
                self.commitCurrentAnswerToScoring()
                self.goToNextQuestion()
            }
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = String(format: "00:%02d", max(secondsRemaining, 0))
    }

    // MARK: - Rendering

    private func showCurrentQuestion() {
        let question = quiz.questions[currentQuestionIndex]

        questionNumberLabel.text = "Question \(currentQuestionIndex + 1) of \(quiz.questions.count)"
        questionLabel.text = question.text

        let progress = Float(currentQuestionIndex + 1) / Float(max(quiz.questions.count, 1))
        progressView.setProgress(progress, animated: true)

        switch question.type {
        case .single:
            instructionLabel.isHidden = false
            instructionLabel.text = "Select one answer"
            setRangedUIHidden(true)
            answersTableView.isHidden = false

        case .multiple:
            instructionLabel.isHidden = false
            instructionLabel.text = "Select all that apply"
            setRangedUIHidden(true)
            answersTableView.isHidden = false

        case .ranged:
            instructionLabel.isHidden = true
            answersTableView.isHidden = true
            setRangedUIHidden(false)

            leftRangeLabel.text = question.answers.first?.text
            rightRangeLabel.text = question.answers.last?.text

            rangeSlider.minimumValue = 0
            rangeSlider.maximumValue = 1
            rangeSlider.value = 0.5
        }

        answersTableView.reloadData()
        startTimer()
    }

    private func setRangedUIHidden(_ hidden: Bool) {
        rangeSlider.isHidden = hidden
        leftRangeLabel.isHidden = hidden
        rightRangeLabel.isHidden = hidden
    }

    // MARK: - Scoring

    /// Converts the user’s selection on the current question into one or more `resultID`s.
    /// This keeps the scoring rules in one place and makes navigation logic cleaner.
    private func commitCurrentAnswerToScoring() {
        let question = quiz.questions[currentQuestionIndex]

        switch question.type {
        case .single:
            guard let index = selectedSingleIndex else { return }
            let resultID = question.answers[index].resultID
            collectedResultIDs.append(resultID)

        case .multiple:
            guard !selectedMultipleIndexes.isEmpty else { return }
            let ids = selectedMultipleIndexes
                .sorted()
                .map { question.answers[$0].resultID }
            collectedResultIDs.append(contentsOf: ids)

        case .ranged:
            // Map slider value (0...1) into A/B/C/D buckets.
            // This works with your current ranged questions that only show endpoints.
            let value = rangeSlider.value
            let resultID: String
            switch value {
            case ..<0.25: resultID = "A"
            case ..<0.50: resultID = "B"
            case ..<0.75: resultID = "C"
            default:      resultID = "D"
            }
            collectedResultIDs.append(resultID)
        }
    }

    /// Returns the most common `resultID`. If there is a tie, it returns the first highest.
    private func dominantResultID() -> String {
        let counts = collectedResultIDs.reduce(into: [String: Int]()) { partial, id in
            partial[id, default: 0] += 1
        }

        // Default to "A" so the UI always has something sensible to show.
        let winner = counts.max(by: { $0.value < $1.value })?.key
        return winner ?? "A"
    }

    /// Builds a display-ready result (title/description) using the quiz title + winning ID.
    private func buildQuizResult() -> QuizResult {
        let winner = dominantResultID()

        // These mappings can be expanded later without changing controller logic.
        let mapping = ResultsViewController.resultMapping(for: quiz.title, resultID: winner)

        return QuizResult(
            quizTitle: quiz.title,
            resultTitle: mapping.title,
            resultDescription: mapping.description,
            dominantResultID: winner
        )
    }

    // MARK: - Navigation

    private func goToNextQuestion() {
        selectedSingleIndex = nil
        selectedMultipleIndexes.removeAll()

        if currentQuestionIndex < quiz.questions.count - 1 {
            currentQuestionIndex += 1
            showCurrentQuestion()
        } else {
            let result = buildQuizResult()
            performSegue(withIdentifier: "showResults", sender: result)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults",
           let destination = segue.destination as? ResultsViewController,
           let result = sender as? QuizResult {
            destination.quizResult = result
        }
    }

    // MARK: - Actions

    @IBAction private func nextTapped(_ sender: UIButton) {
        sender.applyColorFeedback(darkerHex: "3F7DDA")

        let currentQuestion = quiz.questions[currentQuestionIndex]
        if currentQuestion.type == .single, selectedSingleIndex == nil { return }
        if currentQuestion.type == .multiple, selectedMultipleIndexes.isEmpty { return }

        commitCurrentAnswerToScoring()
        goToNextQuestion()
    }

    // MARK: - Selection Helpers

    private func isAnswerSelected(row: Int, questionType: QuestionType) -> Bool {
        switch questionType {
        case .single:
            return selectedSingleIndex == row
        case .multiple:
            return selectedMultipleIndexes.contains(row)
        case .ranged:
            return false
        }
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate

extension QuestionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quiz.questions[currentQuestionIndex].answers.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AnswerCell.reuseIdentifier,
            for: indexPath
        ) as? AnswerCell else {
            return UITableViewCell()
        }

        let question = quiz.questions[currentQuestionIndex]
        let answer = question.answers[indexPath.row]

        cell.configure(text: answer.text, imageName: answer.imageName)

        let selected = isAnswerSelected(row: indexPath.row, questionType: question.type)
        cell.setSelectedAppearance(selected, animated: false)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let tappedCell = tableView.cellForRow(at: indexPath) as? AnswerCell {
            tappedCell.animateTapFeedback()
        }

        let question = quiz.questions[currentQuestionIndex]

        switch question.type {
        case .single:
            if let previous = selectedSingleIndex,
               previous != indexPath.row,
               let previousCell = tableView.cellForRow(at: IndexPath(row: previous, section: 0)) as? AnswerCell {
                previousCell.setSelectedAppearance(false, animated: true)
            }

            selectedSingleIndex = indexPath.row
            selectedMultipleIndexes.removeAll()

            if let tappedCell = tableView.cellForRow(at: indexPath) as? AnswerCell {
                tappedCell.setSelectedAppearance(true, animated: true)
            }

        case .multiple:
            if selectedMultipleIndexes.contains(indexPath.row) {
                selectedMultipleIndexes.remove(indexPath.row)
                if let tappedCell = tableView.cellForRow(at: indexPath) as? AnswerCell {
                    tappedCell.setSelectedAppearance(false, animated: true)
                }
            } else {
                selectedMultipleIndexes.insert(indexPath.row)
                if let tappedCell = tableView.cellForRow(at: indexPath) as? AnswerCell {
                    tappedCell.setSelectedAppearance(true, animated: true)
                }
            }

        case .ranged:
            break
        }
    }
}
