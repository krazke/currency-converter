//
//  MainViewModel.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine

private typealias Module = Main
private typealias ViewModel = Module.ViewModel

extension Module {
    final class ViewModel {
        // MARK: - Dependencies
        
        var router: RouterInterface!
    }
}

extension ViewModel: Module.ViewModelInterface {
    func didLoad() {
        
    }
}
