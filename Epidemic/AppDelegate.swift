//
//  AppDelegate.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 07.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainNavigationController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

