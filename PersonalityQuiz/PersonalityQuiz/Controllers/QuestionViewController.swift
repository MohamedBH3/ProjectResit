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

    // MARK: - Properties

    private var quiz: Quiz!
    private var currentQuestionIndex = 0

    // Used to track selections
    private var selectedSingleIndex: Int?
    private var selectedMultipleIndexes = Set<Int>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableView()
        loadSampleQuiz()
        showCurrentQuestion()
    }

    // MARK: - UI Setup

    private func configureUI() {
        view.backgroundColor = .systemBackground

        // Question number styling
        questionNumberLabel.textColor = UIColor(hex: "282D37")
        questionNumberLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        // Question title styling
        questionLabel.textColor = UIColor(hex: "282D37")
        questionLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)

        // Instruction text styling
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

    // MARK: - Sample Data

    private func loadSampleQuiz() {
        quiz = Quiz(
            id: "food",
            title: "Food Quiz",
            questions: [
                Question(
                    text: "Which food do you prefer?",
                    type: .single,
                    answers: [
                        Answer(text: "Pizza", imageName: "pizza", resultID: "adventurous"),
                        Answer(text: "Sushi", imageName: "sushi", resultID: "adventurous"),
                        Answer(text: "Burger", imageName: "burger", resultID: "classic"),
                        Answer(text: "Salad", imageName: "salad", resultID: "healthy")
                    ]
                )
            ]
        )
    }

    // MARK: - Question Rendering

    private func showCurrentQuestion() {
        let question = quiz.questions[currentQuestionIndex]

        questionNumberLabel.text = "Question \(currentQuestionIndex + 1) of \(quiz.questions.count)"
        questionLabel.text = question.text

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
        }

        answersTableView.reloadData()
    }

    // MARK: - Actions

    @IBAction private func nextTapped(_ sender: UIButton) {
        // Navigation logic will be implemented next
    }
}

// MARK: - Table View DataSource & Delegate

extension QuestionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return quiz.questions[currentQuestionIndex].answers.count
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

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // Selection handling will be implemented next
    }
}
