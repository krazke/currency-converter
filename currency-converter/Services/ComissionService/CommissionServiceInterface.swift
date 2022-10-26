//
//  CommissionServiceInterface.swift
//  currency-converter
//
//  Created by krazke on 24.10.2022.
//

protocol CommissionServiceInterface: AnyService {
    func appendCommission(
        to transaction: Transaction,
        _ completion: @escaping (Result<Transaction, Error>) -> Void
    )
}
