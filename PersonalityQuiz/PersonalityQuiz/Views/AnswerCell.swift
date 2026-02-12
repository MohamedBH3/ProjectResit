import UIKit

// Custom table view cell used for displaying answer cards
final class AnswerCell: UITableViewCell {

    static let reuseIdentifier = "AnswerCell"

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var answerImageView: UIImageView!
    @IBOutlet private weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Remove default cell styling
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        // Card styling
        containerView.backgroundColor = UIColor(hex: "FDFDFE")
        containerView.layer.borderColor = UIColor(hex: "ECECF1").cgColor
        containerView.layer.borderWidth = 1.5
        containerView.layer.cornerRadius = 14

        // Label styling
        answerLabel.textColor = UIColor(hex: "282D37")
        answerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        // Image styling
        answerImageView.contentMode = .scaleAspectFit
    }

    // Configures cell with answer data
    func configure(text: String, imageName: String) {
        answerLabel.text = text
        answerImageView.image = UIImage(named: imageName)
    }
}
