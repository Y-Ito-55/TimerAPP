//
//  AppDelegate.swift
//  TimerAPP
//
//  Created by Yumi Ito on 2023/09/15.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("did recieve")
            if response.actionIdentifier == "returnAction" {
                // 現在のViewControllerを取得して、alarmEnded関数を呼び出す
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let viewController = windowScene.windows.first?.rootViewController as? ViewController {
                        viewController.alarmEnded()
                    }
                }
            }


            // 現在のViewControllerを取得して、背景画像とラベルを更新
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let viewController = windowScene.windows.first?.rootViewController as? ViewController {
                    viewController.updateBackgroundAndLabel()
                }
            }
            completionHandler()
        // 通知が前面で表示されるためのメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent notification")
        completionHandler([.banner, .sound])
        }
    }
}
