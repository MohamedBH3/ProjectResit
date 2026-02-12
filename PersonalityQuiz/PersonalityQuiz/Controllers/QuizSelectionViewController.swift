import UIKit

final class QuizSelectionViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var quizTableView: UITableView!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    private let quizzes: [QuizCategory] = [
        Quiz(title: "Food Quiz",
             subtitle: "Answer fun questions about\nyour food preferences.",
             iconName: "foodIcon"),
        Quiz(title: "Animal Quiz",
             subtitle: "Discover which animal matches\nyour personality!",
             iconName: "animalIcon"),
        Quiz(title: "Music Quiz",
             subtitle: "Find out your music personality\nwith fun questions!",
             iconName: "musicIcon")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureLabels()
        configureButtons()
        configureTableView()
    }

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

    @IBAction private func startQuizTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showQuiz", sender: nil)
    }

    @IBAction private func historyTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showHistory", sender: nil)
    }
}

extension QuizSelectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
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
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
    }
}
