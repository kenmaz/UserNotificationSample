//
//  AppDelegate.swift
//  UserNotificationSample
//
//  Created by Kentaro Matsumae on 2016/07/22.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert]) { (granted, error) in
            if granted {
                UIApplication.shared().registerForRemoteNotifications()
            }
        }
        return true
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(#function)
        let token = deviceToken.description
            .replacingOccurrences(of: "<", with: "", options: [], range: nil)
            .replacingOccurrences(of: ">", with: "", options: [], range: nil)
            .replacingOccurrences(of: " ", with: "", options: [], range: nil)
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(#function)
    }
}

