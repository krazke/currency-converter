//
//  AppDelegate.swift
//  currency-converter
//
//  Created by krazke on 06.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupWindow()
        return true
    }
}

// MARK: - Private

private extension AppDelegate {
    func setupWindow() {
        window = .init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        let navigationController: UINavigationController = .init(rootViewController: ViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

