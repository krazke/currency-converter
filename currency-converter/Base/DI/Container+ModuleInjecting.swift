//
//  Container+ModuleInjecting.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Swinject

extension Container: ModuleInjecting {
    func inject<Dependency>(_ serviceType: Dependency.Type) -> Dependency? {
        synchronize().resolve(serviceType)
    }

    func inject<Dependency>(
        _ serviceType: Dependency.Type,
        name: String
    ) -> Dependency? {
        guard let service: Dependency = synchronize().resolve(serviceType, name: name)
        else { return synchronize().resolve(serviceType) }
        return service
    }
}
