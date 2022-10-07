//
//  MainViewModelInterface.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

private typealias Module = Main

extension Module {
    typealias ViewModelInterface = MainViewModelInterface
}

// MARK: - Interface

protocol MainViewModelInterface {
    func didLoad()
}

