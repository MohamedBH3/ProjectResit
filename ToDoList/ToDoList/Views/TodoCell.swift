import UIKit

final class TodoCell: UITableViewCell {

    // MARK: - Public

    var onToggleCompletion: (() -> Void)?

    func configure(title: String, subtitle: String, subtitleColor: UIColor, isCompleted: Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = subtitleColor

        let iconName = isCompleted ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: iconName)

        statusButton.setImage(image, for: .normal)
        statusButton.tintColor = isCompleted ? .systemBlue : .systemGray3
    }

    // MARK: - UI

    private let cardView = UIView()
    private let statusButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildUI()
    }

    // MARK: - Setup

    private func buildUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Card
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray5.cgColor

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        // Completion circle (bigger like Figma)
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.tintColor = .systemGray3
        statusButton.contentHorizontalAlignment = .center
        statusButton.contentVerticalAlignment = .center
        statusButton.addTarget(self, action: #selector(statusTapped), for: .touchUpInside)
        cardView.addSubview(statusButton)

        // Title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        // Subtitle
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(subtitleLabel)

        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .tertiaryLabel
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            // Card margins
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Status button (bigger)
            statusButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            statusButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            statusButton.widthAnchor.constraint(equalToConstant: 28),
            statusButton.heightAnchor.constraint(equalToConstant: 28),

            // Chevron
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12),

            // Title
            titleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),

            // Subtitle
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }

    @objc private func statusTapped() {
        onToggleCompletion?()
    }
}
