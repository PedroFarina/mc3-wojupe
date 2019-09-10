//
//  AppDelegate.swift
//  Ping
//
//  Created by Pedro Giuliano Farina on 28/08/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //App foi inicializado
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().delegate = self

        application.applicationIconBadgeNumber = 0

        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "firstTime") {
            defaults.setValue(true, forKey: "firstTime")
            let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Tutorial")
            guard let window = self.window else {
                return true
            }
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
        return true
    }

    //App vai ficar inativo
    func applicationWillResignActive(_ application: UIApplication) {

    }

    //App saiu de tela
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    //App vai entrar em tela
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    //App ficou ativo
    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    //App vai fechar
    func applicationWillTerminate(_ application: UIApplication) {

    }
}
