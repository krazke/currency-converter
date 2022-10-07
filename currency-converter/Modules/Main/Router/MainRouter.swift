//
//  MainRouter.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

private typealias Module = Main
private typealias Router = Module.Router

extension Module {
    final class Router {
        // MARK: - Dependencies
        
        weak var view: UIViewController!
    }
}

extension Router: Module.RouterInterface {
    
}
