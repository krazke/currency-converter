//
//  MainViewInterface.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

private typealias Module = Main

extension Module {
    typealias ViewInterface = MainViewInterface
}

// MARK: - Interface

protocol MainViewInterface: AnyObject {
    func display(balances: [Balance])
    func display(
        amount: Float,
        commission: Float,
        isSell: Bool
    )
    func display(error: String)
    func showAlert(
        title: String?,
        message: String?
    )
}
