import UIKit

final class HistoryCell: UITableViewCell {

    static let reuseID = "HistoryCell"

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var quizTitleLabel: UILabel!
    @IBOutlet private weak var resultTitleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
        cardView.backgroundColor = .systemBackground
    }

    func configure(entry: QuizHistoryEntry) {
        quizTitleLabel.text = entry.quizTitle
        resultTitleLabel.text = entry.resultTitle

        resultTitleLabel.textColor = UIColor(hex: "4D8AE0")

        dateLabel.textColor = UIColor(hex: "6A717B")
        dateLabel.text = "Completed on \(Self.formattedDate(entry.completedAt))"
    }

    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
