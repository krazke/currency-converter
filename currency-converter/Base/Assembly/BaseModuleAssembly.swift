//
//  BaseModuleAssembly.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

class BaseModuleAssembly {
    // MARK: - Dependencies

    var injection: ModuleInjecting

    // MARK: - Lifecycle

    required init(injection: ModuleInjecting) {
        self.injection = injection
    }

    convenience init() {
        self.init(injection: Injection.container)
    }
}
