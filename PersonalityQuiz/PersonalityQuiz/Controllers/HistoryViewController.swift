import UIKit

final class HistoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var emptyStateContainer: UIView!
    @IBOutlet private weak var startQuizButton: UIButton!

    private var entries: [QuizHistoryEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "History"
        view.backgroundColor = .systemBackground

        configureTableView()
        styleButton()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        entries = QuizHistoryStore.shared.load()
        updateUI()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
    }

    private func styleButton() {
        startQuizButton.backgroundColor = UIColor(hex: "4D8AE0")
        startQuizButton.layer.cornerRadius = 14
        startQuizButton.setTitleColor(.white, for: .normal)
        startQuizButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    private func updateUI() {
        let isEmpty = entries.isEmpty
        emptyStateContainer.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        tableView.reloadData()
    }

    @IBAction private func startQuizTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryCell.reuseID,
            for: indexPath
        ) as? HistoryCell else {
            return UITableViewCell()
        }

        cell.configure(entry: entries[indexPath.row])
        return cell
    }
}
