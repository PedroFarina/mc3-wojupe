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

    func preparePushNotifications(for application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (permitted, error)
            in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            CloudKitNotification.permitted = permitted
            CloudKitNotification.createSubscription { (_) in}
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}
