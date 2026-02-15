import UIKit

final class TodoCell: UITableViewCell {

    private let cardView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = false

        // Subtle shadow like your Figma cards
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)

        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Put the default cell labels inside the card
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.translatesAutoresizingMaskIntoConstraints = false

        if let imageView, let textLabel, let detailTextLabel {
            cardView.addSubview(imageView)
            cardView.addSubview(textLabel)
            cardView.addSubview(detailTextLabel)

            textLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            detailTextLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            detailTextLabel.numberOfLines = 1

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
                imageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 24),
                imageView.heightAnchor.constraint(equalToConstant: 24),

                textLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
                textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
                textLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -16),

                detailTextLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4),
                detailTextLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                detailTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -16),
                detailTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -16)
            ])
        }

        // Keeps chevron outside the card nicer
        separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
    }
}
