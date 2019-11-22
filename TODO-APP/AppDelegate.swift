import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { didAllow, _ in
            if !didAllow {
                print("User has declined notifcations.")
            }
        }
        notificationCenter.getNotificationSettings { settings in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
        func scheduleNotification(notifcationType: String) {
            let content = UNMutableNotificationContent()
            content.title = "Todo Completed"
            content.subtitle = "Your Todo \(notifcationType)"
            content.sound = UNNotificationSound.default
        }
        return true
    }
}
