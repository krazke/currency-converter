//
//  MainView.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

private typealias Module = Main
private typealias View = Module.View

extension Module {
    final class View: UIViewController {
        // MARK: - Dependencies
        
        var viewModel: ViewModelInterface!
        
        // MARK: - Properties
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            viewModel.didLoad()
        }
    }
}
