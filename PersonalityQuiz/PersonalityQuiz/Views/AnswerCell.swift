import UIKit

// Custom table view cell used for displaying answer cards
final class AnswerCell: UITableViewCell {

    static let reuseIdentifier = "AnswerCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    

        // MARK: - Colors / Constants (Figma)

        private enum Style {
            static let normalFill = UIColor(hex: "FDFDFE")
            static let normalStroke = UIColor(hex: "ECECF1").cgColor

            static let selectedFill = UIColor(hex: "ECF2FD")
            static let selectedStroke = UIColor(hex: "D9E0ED").cgColor

            static let borderWidth: CGFloat = 1.5
            static let cornerRadius: CGFloat = 14
        }
    
    // MARK: - Press feedback

    // Animates the entire card so icon + text scale together.
    func animatePress() {
        UIView.animate(withDuration: 0.10, delay: 0, options: [.curveEaseOut], animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }, completion: { _ in
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseInOut], animations: {
                self.containerView.transform = .identity
            })
        })
    }
        // MARK: - Lifecycle

        override func awakeFromNib() {
            super.awakeFromNib()
            configureBaseAppearance()
            applySelectedAppearance(false, animated: false)
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            applySelectedAppearance(false, animated: false)
        }

        // MARK: - Public API

        // Sets the content (text + left image) for an answer.
        func configure(text: String, imageName: String) {
            answerLabel.text = text
            answerImageView.image = UIImage(named: imageName)
        }

        // Applies selected/unselected styling. Call this from the table view whenever selection changes.
        func setSelectedAppearance(_ isSelected: Bool, animated: Bool) {
            applySelectedAppearance(isSelected, animated: animated)
        }

        // MARK: - Private Helpers

        private func configureBaseAppearance() {
            backgroundColor = .clear
            contentView.backgroundColor = .clear
            selectionStyle = .none

            containerView.layer.cornerRadius = Style.cornerRadius
            containerView.layer.borderWidth = Style.borderWidth

            answerLabel.textColor = UIColor(hex: "282D37")
            answerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

            answerImageView.contentMode = .scaleAspectFit

            accessoryImageView.contentMode = .scaleAspectFit
        }

        private func applySelectedAppearance(_ isSelected: Bool, animated: Bool) {
            let updates = {
                self.containerView.backgroundColor = isSelected ? Style.selectedFill : Style.normalFill
                self.containerView.layer.borderColor = isSelected ? Style.selectedStroke : Style.normalStroke

                if isSelected {
                    self.accessoryImageView.image = UIImage(systemName: "checkmark.circle.fill")
                    self.accessoryImageView.tintColor = UIColor(hex: "4D8AE0")
                } else {
                    self.accessoryImageView.image = UIImage(systemName: "chevron.right")
                    self.accessoryImageView.tintColor = UIColor(hex: "6A717B")
                }
            }

            guard animated else {
                updates()
                return
            }

            UIView.animate(withDuration: 0.12,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                updates()
                self.containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }, completion: { _ in
                UIView.animate(withDuration: 0.12,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                    self.containerView.transform = .identity
                })
            })
        }
    }
