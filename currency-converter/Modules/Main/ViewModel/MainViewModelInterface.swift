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
    var sellAmount: Float? { get set }
    var sellCurrency: String? { get set }
    var buyAmount: Float? { get set }
    var buyCurrency: String? { get set }
    
    func didLoad()
    func didTouchSubmit()
}

