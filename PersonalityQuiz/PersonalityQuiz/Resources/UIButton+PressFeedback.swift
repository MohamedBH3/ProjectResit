import UIKit

// Centralized press feedback for buttons.
// This is designed to be used with `.touchDown` + `.touchUpInside/.touchUpOutside/.touchCancel`
// so users get instant feedback when their finger touches the button.
extension UIButton {

    // Animates the button into a pressed state (slight scale down + slight opacity change).
    func animatePressedDown() {
        UIView.animate(
            withDuration: 0.08,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            self.alpha = 0.90
        }
    }

    // Animates the button back to its normal state.
    func animateReleased() {
        UIView.animate(
            withDuration: 0.14,
            delay: 0,
            options: [.curveEaseInOut, .allowUserInteraction]
        ) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }

    // Temporarily darkens the background color and restores it.
    // Used for “filled” buttons where a color shift improves feedback clarity.
    func applyColorFeedback(darkerHex: String) {
        let originalColor = backgroundColor

        UIView.animate(withDuration: 0.08, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            self.backgroundColor = UIColor(hex: darkerHex)
        } completion: { _ in
            UIView.animate(withDuration: 0.14, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                self.backgroundColor = originalColor
            }
        }
    }
}
