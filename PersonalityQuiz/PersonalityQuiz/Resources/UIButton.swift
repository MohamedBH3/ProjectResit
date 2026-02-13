import UIKit

// Centralized press feedback for buttons.
// Keeps view controllers focused on navigation/logic and avoids duplicated animation code.
extension UIButton {

    // Applies a subtle “press” animation (scale + opacity) and restores the original state.
    func applyPressFeedback() {
        UIView.animate(withDuration: 0.08,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            self.alpha = 0.88
        }, completion: { _ in
            UIView.animate(withDuration: 0.12,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                self.transform = .identity
                self.alpha = 1.0
            })
        })
    }

    // Temporarily switches the background color to a darker tone and then restores it.
    // This should be used for buttons that already have a background color set.
    func applyColorFeedback(darkerHex: String) {
        let originalColor = backgroundColor

        UIView.animate(withDuration: 0.08,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
            self.backgroundColor = UIColor(hex: darkerHex)
        }, completion: { _ in
            UIView.animate(withDuration: 0.12,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: {
                self.backgroundColor = originalColor
            })
        })
    }
}
