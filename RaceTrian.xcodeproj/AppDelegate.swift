import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        print("🟣 AppDelegate: didFinishLaunchingWithOptions")
        
        // Add any app initialization code here
        
        return true
    }
    
    // MARK: - Push Notifications
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("🟣 AppDelegate: Registered for remote notifications with token: \(token)")
        
        // Handle the device token (e.g., send to your server)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("🟣 AppDelegate: Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // MARK: - URL Handling
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        print("🟣 AppDelegate: Opening URL: \(url)")
        
        // Handle URL schemes here
        
        return true
    }
    
    // MARK: - Background Tasks
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("🟣 AppDelegate: Did enter background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("🟣 AppDelegate: Will enter foreground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("🟣 AppDelegate: Did become active")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("🟣 AppDelegate: Will resign active")
    }
}
