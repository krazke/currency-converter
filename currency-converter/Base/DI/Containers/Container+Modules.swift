//
//  Container+Modules.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Swinject

extension Container {
    func registerModules() -> Container {
        register(Main.Assemblying.self) { _ in
            Main.Assembly()
        }
        
        return self
    }
}
