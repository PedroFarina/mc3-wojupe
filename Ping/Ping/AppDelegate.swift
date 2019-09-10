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
