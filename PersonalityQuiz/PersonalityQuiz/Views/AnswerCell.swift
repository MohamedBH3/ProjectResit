import UIKit

/// Custom table view cell used for displaying answer cards.
/// The tap feedback scales all visible elements together to match the selection-screen behavior.
///
/// Storyboard hierarchy (your current setup):
/// - contentView
///   - containerView
///       - answerImageView
///   - answerLabel
///   - accessoryImageView
final class AnswerCell: UITableViewCell {

    static let reuseIdentifier = "AnswerCell"

    // MARK: - IBOutlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!

    // MARK: - Style

    private enum Style {
        static let normalFill = UIColor(hex: "FDFDFE")
        static let normalStroke = UIColor(hex: "ECECF1").cgColor

        static let selectedFill = UIColor(hex: "ECF2FD")
        static let selectedStroke = UIColor(hex: "D9E0ED").cgColor

        static let borderWidth: CGFloat = 1.5
        static let cornerRadius: CGFloat = 14

        static let tapScale: CGFloat = 0.97
        static let tapDownDuration: TimeInterval = 0.09
        static let tapUpDuration: TimeInterval = 0.14
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureBaseAppearance()
        applySelectedAppearance(false, animated: false)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Ensure reused cells don’t keep an old scale state.
        resetTapTransforms()

        applySelectedAppearance(false, animated: false)
    }

    // MARK: - Tap Feedback (Triggered by Controller)

    /// Call this from `didSelectRowAt` so the animation is on TAP (not press-and-hold).
    /// Scales the full “card” content based on your storyboard hierarchy.
    func animateTapFeedback() {
        let targets = tapTargets()

        UIView.animate(
            withDuration: Style.tapDownDuration,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                for view in targets {
                    view.transform = CGAffineTransform(scaleX: Style.tapScale, y: Style.tapScale)
                }
            },
            completion: { _ in
                UIView.animate(
                    withDuration: Style.tapUpDuration,
                    delay: 0,
                    options: [.curveEaseInOut, .allowUserInteraction],
                    animations: {
                        for view in targets {
                            view.transform = .identity
                        }
                    }
                )
            }
        )
    }

    // MARK: - Public API

    func configure(text: String, imageName: String) {
        answerLabel.text = text
        answerImageView.image = UIImage(named: imageName)
    }

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

        guard animated else { updates(); return }
        UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseInOut], animations: updates)
    }

    /// Views that must scale together given your storyboard hierarchy.
    /// - `containerView` scales the icon (since the icon is inside it)
    /// - `answerLabel` is a sibling (must be scaled explicitly)
    /// - `accessoryImageView` is a sibling (must be scaled explicitly)
    private func tapTargets() -> [UIView] {
        [containerView, answerLabel, accessoryImageView]
    }

    private func resetTapTransforms() {
        for view in tapTargets() {
            view.transform = .identity
        }
    }
}
