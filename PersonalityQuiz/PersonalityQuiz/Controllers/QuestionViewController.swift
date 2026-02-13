import UIKit

// Handles presentation and logic of quiz questions
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

        // MARK: - Passed In From Previous Screen

        // Set in QuizSelectionViewController.prepare(for:sender:)
        var quizCategory: QuizCategory!

        // MARK: - Quiz State

        private var quiz: Quiz!
        private var currentQuestionIndex = 0

        // Used to track what the user selected
        private var selectedSingleIndex: Int?
        private var selectedMultipleIndexes = Set<Int>()

        // MARK: - Timer State

        private var secondsRemaining: Int = 15
        private var timer: Timer?

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            // Apply screen styling
            configureUI()

            // Setup answers list
            configureTableView()

            // Build quiz content based on selected category
            buildQuizFromSelection()

            // Render the first question
            showCurrentQuestion()

            // Start countdown timer for the question
            startTimer()
        }

        // MARK: - Quiz Building

        // Converts the selected category into a full Quiz model
        private func buildQuizFromSelection() {
            let id = quizCategory.title.lowercased().replacingOccurrences(of: " ", with: "_")

            quiz = Quiz(
                id: id,
                title: quizCategory.title,
                questions: QuizFactory.makeQuestions(for: quizCategory.title)
            )
        }

        // MARK: - UI Setup

        private func configureUI() {
            view.backgroundColor = .systemBackground

            // Question number styling
            questionNumberLabel.textColor = UIColor(hex: "282D37")
            questionNumberLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

            // Question text styling
            questionLabel.textColor = UIColor(hex: "282D37")
            questionLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)

            // Instruction styling
            instructionLabel.textColor = UIColor(hex: "6A717B")
            instructionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

            // Timer styling
            timerLabel.textColor = UIColor(hex: "4D8AE0")
            timerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            timerLabel.text = "00:15"

            // Progress bar styling
            progressView.progress = 0.1
            progressView.trackTintColor = UIColor(hex: "ECECF1")
            progressView.progressTintColor = UIColor(hex: "4D8AE0")

            // Next button styling
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
        }

        // MARK: - Timer

        // Starts/restarts the countdown timer for each question
        private func startTimer() {
            timer?.invalidate()

            secondsRemaining = 15
            timerLabel.text = String(format: "00:%02d", secondsRemaining)

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self else { return }

                self.secondsRemaining -= 1
                self.timerLabel.text = String(format: "00:%02d", max(self.secondsRemaining, 0))

                if self.secondsRemaining <= 0 {
                    self.timer?.invalidate()
                    self.handleTimeExpired()
                }
            }
        }

        // Called when the timer reaches zero
        private func handleTimeExpired() {
            goToNextQuestion()
        }

        // MARK: - Question Rendering

        private func showCurrentQuestion() {
            let question = quiz.questions[currentQuestionIndex]

            // Update header text
            questionNumberLabel.text = "Question \(currentQuestionIndex + 1) of \(quiz.questions.count)"
            questionLabel.text = question.text

            // Update progress bar
            progressView.progress = Float(currentQuestionIndex + 1) / Float(quiz.questions.count)

            // Show correct UI based on question type
            switch question.type {

            case .single:
                instructionLabel.text = "Select one answer"

                answersTableView.isHidden = false
                rangeSlider.isHidden = true
                leftRangeLabel.isHidden = true
                rightRangeLabel.isHidden = true

            case .multiple:
                instructionLabel.text = "Select all that apply"

                answersTableView.isHidden = false
                rangeSlider.isHidden = true
                leftRangeLabel.isHidden = true
                rightRangeLabel.isHidden = true

            case .ranged:
                instructionLabel.text = "Move the slider"

                answersTableView.isHidden = true
                rangeSlider.isHidden = false
                leftRangeLabel.isHidden = false
                rightRangeLabel.isHidden = false

                // (4) PUT THIS CODE RIGHT HERE:
                // Configure the range UI using the first and last answer labels
                leftRangeLabel.text = question.answers.first?.text
                rightRangeLabel.text = question.answers.last?.text

                // Slider configured as a normalized 0...1 control
                rangeSlider.minimumValue = 0
                rangeSlider.maximumValue = 1
                rangeSlider.value = 0.5
            }

            // Reload answers for single/multiple questions
            answersTableView.reloadData()
        }

        // MARK: - Navigation Logic

        private func goToNextQuestion() {
            // Reset selection state when moving forward
            selectedSingleIndex = nil
            selectedMultipleIndexes.removeAll()

            // Advance if there are more questions, otherwise go to results
            if currentQuestionIndex < quiz.questions.count - 1 {
                currentQuestionIndex += 1
                showCurrentQuestion()
                startTimer()
            } else {
                performSegue(withIdentifier: "showResults", sender: nil)
            }
        }

        // MARK: - Actions

        @IBAction private func nextTapped(_ sender: UIButton) {
            goToNextQuestion()
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

            let answer = quiz.questions[currentQuestionIndex].answers[indexPath.row]
            cell.configure(text: answer.text, imageName: answer.imageName)
            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            90
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let question = quiz.questions[currentQuestionIndex]

            switch question.type {

            case .single:
                // Save only one selected row
                selectedSingleIndex = indexPath.row
                selectedMultipleIndexes.removeAll()

            case .multiple:
                // Toggle selection in the set
                if selectedMultipleIndexes.contains(indexPath.row) {
                    selectedMultipleIndexes.remove(indexPath.row)
                } else {
                    selectedMultipleIndexes.insert(indexPath.row)
                }

            case .ranged:
                // Ranged selection is read from the slider value
                break
            }
        }
    }
