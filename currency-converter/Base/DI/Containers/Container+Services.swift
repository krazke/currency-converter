//
//  Container+Services.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Swinject

extension Container {
    func registerServices() -> Container {
        register(NetworkingServiceInterface.self) { _ in
            NetworkingService()
        }
        register(DatabaseServiceInterface.self) { _ in
            DatabaseService()
        }
        register(ExchangeServiceInterface.self) { resolver in
            ExchangeService(
                networking: resolver.resolve(NetworkingServiceInterface.self)!,
                database: resolver.resolve(DatabaseServiceInterface.self)!
            )
        }
        register(CommissionServiceInterface.self) { resolver in
            CommissionService(
                exchangeService: resolver.resolve(ExchangeServiceInterface.self)!
            )
        }
        
        return self
    }
}
