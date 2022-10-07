//
//  AppDelegate.swift
//  currency-converter
//
//  Created by krazke on 06.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - UI Elements
    
    var window: UIWindow?
    
    // MARK: - Properties
    
    private var injection: ModuleInjecting!
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        prelaunchSetup()
        return true
    }
}

// MARK: - Private

private extension AppDelegate {
    func prelaunchSetup() {
        // Disable autolayout errors in console
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        Injection.mode = .standart
        injection = Injection.container
        setupWindow(injection)
    }
    
    func setupWindow(_ injection: ModuleInjecting) {
        window = .init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        let main: UIViewController = injection.inject(Main.Assemblying.self)!.assemble()
        let navigationController: UINavigationController = .init(rootViewController: main)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

