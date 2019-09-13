//
//  CloudKit Notification.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 10/09/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import CloudKit
import UserNotifications
import UIKit

public class CloudKitNotification {
    private init() {
    }

    private static let defaults = UserDefaults.standard
    public static var permitted: Bool = defaults.bool(forKey: "notificationPermitted") {
        didSet {
            defaults.set(permitted, forKey: "notificationPermitted")
        }
    }

    public static func askPermission() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("O app não tem um App Delegate.")
        }
        if !permitted {
            delegate.perparePushNotifications(for: UIApplication.shared)
        }
    }

    public static func createSubscription() {
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let subscription = CKQuerySubscription(
            recordType: "Notification", predicate: predicate, options: .firesOnRecordCreation)

        let info = CKSubscription.NotificationInfo()

        info.titleLocalizationKey = "Alguém está na %1$@".localized()
        info.titleLocalizationArgs = ["NomeCampainha"]
        info.subtitleLocalizationKey = "%1$@ chegou!"
        info.subtitleLocalizationArgs = ["NomeVisitante"]

        info.shouldBadge = true

        info.soundName = "default"

        subscription.notificationInfo = info

        CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        })
    }

    public static func updateSubscription() {

    }

    public static func resetBadge() {
        DataController.shared().resetBadges()
    }
}
