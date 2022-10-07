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
            let router = Router()
            let viewModel = ViewModel()
            let view = View()
            
            router.view = view
            viewModel.router = router
            view.viewModel = viewModel
            
            return view
        }
    }
}
