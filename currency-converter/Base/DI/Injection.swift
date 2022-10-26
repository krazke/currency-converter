//
//  Injection.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Swinject

enum Injection {
    // MARK: - Internal

    enum InjectionMode {
        case standart
    }

    // MARK: - Properties

    static var mode: InjectionMode = .standart {
        didSet {
            switch mode {
            case .standart:
                container = buildStandartContainer()
            }
        }
    }

    // MARK: - Containers

    static var container: ModuleInjecting!

    // MARK: - Private

    private static func buildStandartContainer() -> Container {
        let serviceContainer: Container = Container(
            defaultObjectScope: .container
        )
        .registerServices()
        let moduleContainer: Container = Container(
            parent: serviceContainer,
            defaultObjectScope: .transient
        )
        .registerUtility()
        .registerModules()

        return moduleContainer
    }
}
