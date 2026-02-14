import UIKit

/// Card-style table cell used on the quiz selection screen.
/// Selection styling matches Figma, and press feedback is triggered by the controller on tap.
final class QuizCardCell: UITableViewCell {

    static let reuseIdentifier = "QuizCardCell"

    // MARK: - UI Elements

    private let cardView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    /// Single accessory view that switches between chevron and checkmark.
    private let accessoryImageView = UIImageView()

    // MARK: - Style Constants

    private enum Style {
        static let normalFill = UIColor(hex: "FDFDFE")
        static let normalStroke = UIColor(hex: "ECECF1").cgColor

        static let selectedFill = UIColor(hex: "ECF2FD")
        static let selectedStroke = UIColor(hex: "D9E0ED").cgColor

        static let borderWidth: CGFloat = 1.5
        static let cornerRadius: CGFloat = 14
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setSelectedAppearance(false, animated: false)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        setSelectedAppearance(false, animated: false)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Ensure reused cells never keep a pressed scale.
        cardView.transform = .identity
        cardView.alpha = 1.0
    }

    // MARK: - Tap Feedback

    /// Tap feedback shown when the row is selected.
    /// This is intentionally triggered from `didSelectRowAt` so it feels like a tap (not a hold).
    func animateTapFeedback() {
        UIView.animate(withDuration: 0.09, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            self.cardView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        } completion: { _ in
            UIView.animate(withDuration: 0.14, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                self.cardView.transform = .identity
            }
        }
    }

    // MARK: - UI Setup

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.layer.cornerRadius = Style.cornerRadius
        cardView.layer.borderWidth = Style.borderWidth
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(hex: "282D37")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "6A717B")
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(iconImageView)
        cardView.addSubview(textStack)
        cardView.addSubview(accessoryImageView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),

            accessoryImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            accessoryImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 22),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 22),

            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 14),
            textStack.trailingAnchor.constraint(equalTo: accessoryImageView.leadingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }

    // MARK: - Content

    func configure(with quiz: QuizCategory) {
        titleLabel.text = quiz.title
        subtitleLabel.text = quiz.subtitle
        iconImageView.image = UIImage(named: quiz.iconName)
    }

    // MARK: - Selection UI

    func setSelectedAppearance(_ isSelected: Bool, animated: Bool) {
        let updates = {
            self.cardView.backgroundColor = isSelected ? Style.selectedFill : Style.normalFill
            self.cardView.layer.borderColor = isSelected ? Style.selectedStroke : Style.normalStroke

            if isSelected {
                self.accessoryImageView.image = UIImage(systemName: "checkmark.circle.fill")
                self.accessoryImageView.tintColor = UIColor(hex: "4D8AE0")
            } else {
                self.accessoryImageView.image = UIImage(systemName: "chevron.right")
                self.accessoryImageView.tintColor = UIColor(hex: "6A717B")
            }
        }

        guard animated else { updates(); return }
        UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseInOut], animations: updates)
    }
}
