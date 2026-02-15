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

        // Make the label behave like a normal label (no weird attributed/link styling).
        resultTitleLabel.numberOfLines = 1
        resultTitleLabel.lineBreakMode = .byTruncatingTail
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        quizTitleLabel.text = nil
        resultTitleLabel.text = nil
        resultTitleLabel.attributedText = nil
        dateLabel.text = nil
    }

    func configure(entry: QuizHistoryEntry) {
        quizTitleLabel.text = entry.quizTitle

        // Ensure plain text (not attributed) so it can’t render like a link.
        resultTitleLabel.attributedText = nil
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
