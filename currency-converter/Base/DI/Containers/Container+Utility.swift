//
//  Container+Utility.swift
//  currency-converter
//
//  Created by krazke on 25.10.2022.
//

import Swinject

extension Container {
    func registerUtility() -> Container {
        register(KeyboardObserverInterface.self) { _ in
            KeyboardObserver()
        }
        
        return self
    }
}
