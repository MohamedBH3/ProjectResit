import Foundation
import UserNotifications

enum NotificationScheduler {

    static func scheduleNotification(for todo: Todo) {
        guard todo.reminderEnabled, let dueDate = todo.dueDate, !todo.isCompleted else {
            cancelNotification(for: todo.id)
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "To-Do Reminder"
        content.body = todo.title
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: dueDate
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(
            identifier: todo.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    static func cancelNotification(for id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
}
