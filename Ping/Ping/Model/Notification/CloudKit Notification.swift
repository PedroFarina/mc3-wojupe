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
        delegate.preparePushNotifications(for: UIApplication.shared)
    }

    public static func createSubscription() {
        guard let usuario = DataController.shared().getUsuario else {
            fatalError("Não existe um usuário para fazer a subscription")
        }
        if usuario.idSubscription.value != nil {
            return
        }
        let predicate = NSPredicate(format: "idGrupo IN %@", usuario.grupos.recordReferences)
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

        CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: { record, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if let record = record {
                DataController.shared().editarUsuario(target: usuario, idSubscription: record.subscriptionID)
            }
        })
    }

    public static func updateSubscription() {
        deleteSubscription {
            createSubscription()
        }
    }

    public static func deleteSubscription(completionHandler: @escaping () -> Void) {
        guard let usuario = DataController.shared().getUsuario else {
            fatalError("Não existe um usuário para puxar a subscription")
        }
        guard let idSubscription = usuario.idSubscription.value else {
            completionHandler()
            return
        }
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withSubscriptionID: idSubscription) { (sub, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if let sub = sub {
                publicDB.delete(withSubscriptionID: sub.subscriptionID, completionHandler: { (_, error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    completionHandler()
                })
            }
        }
    }

    public static func resetBadge() {
        DataController.shared().resetBadges()
    }
}
