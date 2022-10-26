//
//  AppDelegate.swift
//  currency-converter
//
//  Created by krazke on 06.10.2022.
//

import UIKit
import DropDown

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - UI Elements
    
    var window: UIWindow?
    
    // MARK: - Properties
    
    private var injection: ModuleInjecting!
    
    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        prelaunchSetup()
        return true
    }
}

// MARK: - Private

private extension AppDelegate {
    func prelaunchSetup() {
        // Disable autolayout errors in console
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        #if DEBUG
        NetworkingConfiguration.mode = .staging
        #else
        NetworkingConfiguration.mode = .production
        #endif
        Injection.mode = .standart
        injection = Injection.container
        setupWindow(injection)
        setupDropDownAppearance()
    }
    
    func setupWindow(_ injection: ModuleInjecting) {
        window = .init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        let main: UIViewController = injection.inject(Main.Assemblying.self)!.assemble()
        let navigationController: UINavigationController = .init(rootViewController: main)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func setupDropDownAppearance() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.white
        DropDown.appearance().textFont = .systemFont(ofSize: 17.0, weight: .semibold)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
    }
}

