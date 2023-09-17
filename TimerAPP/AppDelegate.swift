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
    
    // ...
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did recieve")
        
        // 現在のViewControllerを取得
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController as? ViewController {
            
            // アラーム終了のアクションを処理
            if response.actionIdentifier == "returnAction" {
                viewController.alarmEnded()
            }
            
            // アプリが前面にある場合のみ、背景画像とラベルを更新
            let appState = UIApplication.shared.applicationState
            if appState == .active {
                viewController.updateBackgroundAndLabel()
            }
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent notification")
        completionHandler([.banner, .sound, .badge]) // アプリの状態に関係なく、これらのオプションで通知を表示します。
    }
}

