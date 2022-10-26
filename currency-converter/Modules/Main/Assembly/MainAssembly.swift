//
//  MainAssembly.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

private typealias Module = Main

extension Module {
    final class Assembly: BaseModuleAssembly, Assemblying {
        func assemble() -> UIViewController {
            let viewModel = ViewModel(
                exchangeService: injection.inject(ExchangeServiceInterface.self)!,
                commissionService: injection.inject(CommissionServiceInterface.self)!
            )
            let view = View()
            view.keyboardObserver = injection.inject(KeyboardObserverInterface.self)!
            
            viewModel.view = view
            view.viewModel = viewModel
            
            return view
        }
    }
}
