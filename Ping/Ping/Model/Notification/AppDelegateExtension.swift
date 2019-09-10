//
//  AppDelegateExtension.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 10/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UserNotifications
import UIKit

extension AppDelegate: UNUserNotificationCenterDelegate {
    // When user allowed push notification and the app has gotten the device token
    // (device token is a unique ID that Apple server use to determine which device to send push notification to)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        CloudKitNotification.createSubscription()
    }

    // This function will be called when the app receive notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter, willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .sound])
    }

    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // tell the app that we have finished processing the user’s action (eg: tap on notification banner) / response
        completionHandler()
    }

    func perparePushNotifications(for application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }

            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}
