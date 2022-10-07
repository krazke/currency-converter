//
//  MainAssemblying.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

enum Main {
    typealias Assemblying = MainAssemblying
}

protocol MainAssemblying {
    func assemble() -> UIViewController
}
