//
//  ModuleInjecting.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

protocol ModuleInjecting {
    @discardableResult
    func inject<Dependency>(_ serviceType: Dependency.Type) -> Dependency?
    @discardableResult
    func inject<Dependency>(
        _ serviceType: Dependency.Type,
        name: String
    ) -> Dependency?
}
