import UIKit

/// Displays the final quiz result based on the user’s answers.
final class ResultsViewController: UIViewController {

    // MARK: - IBOutlets (Storyboard)

    @IBOutlet private weak var congratsLabel: UILabel!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var resultTitleLabel: UILabel!
    @IBOutlet private weak var resultBodyLabel: UILabel!

    @IBOutlet private weak var viewHistoryButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var restartButton: UIButton!

    // MARK: - Input

    /// Passed from `QuestionViewController` via `prepare(for:sender:)`.
    var quizResult: QuizResult!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        renderResult()
        wireButtonFeedback()
    }

    // MARK: - UI

    private func configureUI() {
        view.backgroundColor = .systemBackground

        congratsLabel.textColor = UIColor(hex: "6A717B")
        congratsLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        headlineLabel.textColor = UIColor(hex: "282D37")
        headlineLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)

        resultTitleLabel.textColor = UIColor(hex: "4D8AE0")
        resultTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        resultTitleLabel.numberOfLines = 0

        resultBodyLabel.textColor = UIColor(hex: "6A717B")
        resultBodyLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        resultBodyLabel.numberOfLines = 0

        stylePrimaryButton(restartButton, baseHex: "4D8AE0")
        styleSecondaryButton(viewHistoryButton)
        styleSecondaryButton(shareButton)
    }

    private func stylePrimaryButton(_ button: UIButton, baseHex: String) {
        button.backgroundColor = UIColor(hex: baseHex)
        button.layer.cornerRadius = 14
        button.setTitleColor(UIColor(hex: "FEFEFE"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    private func styleSecondaryButton(_ button: UIButton) {
        button.backgroundColor = UIColor(hex: "4D8AE0")
        button.layer.cornerRadius = 14
        button.setTitleColor(UIColor(hex: "FEFEFE"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

    private func renderResult() {
        congratsLabel.text = "Congratulations! You've completed the quiz."
        headlineLabel.text = "Your \(quizResult.quizTitle.lowercased()) personality is..."
        resultTitleLabel.text = quizResult.resultTitle
        resultBodyLabel.text = quizResult.resultDescription
    }

    // MARK: - Button Feedback

    private func wireButtonFeedback() {
        [viewHistoryButton, shareButton, restartButton].forEach { button in
            button?.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button?.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchCancel, .touchDragExit])
        }
    }

    @objc private func buttonTouchDown(_ sender: UIButton) {
        sender.animatePressedDown()
    }

    @objc private func buttonTouchUp(_ sender: UIButton) {
        sender.animateReleased()
    }

    // MARK: - Actions

    @IBAction private func viewHistoryTapped(_ sender: UIButton) {
        sender.applyColorFeedback(darkerHex: "3F7DDA")
        performSegue(withIdentifier: "showHistory", sender: nil)
    }

    @IBAction private func shareTapped(_ sender: UIButton) {
        sender.applyColorFeedback(darkerHex: "3F7DDA")

        let shareText = buildShareText()

        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )

        // Sets an email/AirDrop style subject where supported.
        activityVC.setValue("My \(quizResult.quizTitle) Result", forKey: "subject")

        // iPad safety: anchor the popover to the share button.
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }

        present(activityVC, animated: true)
    }

    private func buildShareText() -> String {
        // Example:
        // I got The Bold Food Explorer on the Food Quiz 🍽️
        // “You’re drawn to strong flavors...”
        // What did you get?
        let emoji = quizEmoji(for: quizResult.quizTitle)

        let titleLine = "I got \(quizResult.resultTitle) on the \(quizResult.quizTitle) \(emoji)"
        let descriptionLine = "“\(quizResult.resultDescription)”"
        let ctaLine = "What did you get?"

        return [titleLine, descriptionLine, ctaLine].joined(separator: "\n")
    }

    private func quizEmoji(for quizTitle: String) -> String {
        switch quizTitle {
        case "Food Quiz": return "🍽️"
        case "Animal Quiz": return "🐾"
        case "Music Quiz": return "🎧"
        default: return "✨"
        }
    }

    @IBAction private func restartTapped(_ sender: UIButton) {
        sender.applyColorFeedback(darkerHex: "3F7DDA")

        // Pops back to the quiz selection screen (assuming it is in the navigation stack).
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Result Mapping

    /// Central mapping from `(quizTitle, resultID)` → display title/description.
    /// This is kept static so `QuestionViewController` can reuse it without creating duplicates.
    static func resultMapping(for quizTitle: String, resultID: String) -> (title: String, description: String) {

        switch quizTitle {
        case "Food Quiz":
            switch resultID {
            case "A":
                return ("The Classic Comfort Lover",
                        "You enjoy familiar favorites and love meals that feel warm, reliable, and satisfying.")
            case "B":
                return ("The Curious Taster",
                        "You like variety and enjoy discovering new flavors, cuisines, and combinations.")
            case "C":
                return ("The Bold Food Explorer",
                        "You’re drawn to strong flavors and aren’t afraid to try something adventurous.")
            default:
                return ("The Adventurous Eater",
                        "You’re always eager to explore new dishes and tastes, and you’re one of the first to try unfamiliar foods.")
            }

        case "Animal Quiz":
            switch resultID {
            case "A":
                return ("The Confident Leader",
                        "You’re bold, driven, and naturally take charge in group settings.")
            case "B":
                return ("The Playful Spirit",
                        "You’re friendly, energetic, and bring a positive vibe wherever you go.")
            case "C":
                return ("The Thoughtful Observer",
                        "You’re reflective, perceptive, and tend to notice details others miss.")
            default:
                return ("The Loyal Companion",
                        "You value connection, consistency, and being there for the people you care about.")
            }

        case "Music Quiz":
            switch resultID {
            case "A":
                return ("The Feel-Good Listener",
                        "You gravitate toward upbeat tracks and music that matches your positive energy.")
            case "B":
                return ("The High-Energy Performer",
                        "You love intensity and momentum—music that keeps you moving and motivated.")
            case "C":
                return ("The Trendsetter",
                        "You stay current, enjoy variety, and like music that reflects culture and creativity.")
            default:
                return ("The Calm Aesthete",
                        "You enjoy balance and atmosphere—music that feels elegant, peaceful, and timeless.")
            }

        default:
            return ("Your Result",
                    "Your answers have been recorded. This result mapping can be expanded for additional quizzes.")
        }
    }
}
