//
//  ExchangeServiceInterface.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine

protocol ExchangeServiceInterface: AnyService {
    var balances: AnyPublisher<[Balance], Never> { get }
    var transactions: AnyPublisher<[Transaction], Never> { get }
    
    func exchange(
        _ request: ExchangeRequest,
        _ completion: @escaping (Result<ExchangeResponse, Error>) -> Void
    )
    func validateExchange(
        transaction: Transaction,
        _ completion: @escaping (Error?) -> Void
    )
    func add(
        transaction: TransactionModel,
        _ completion: ((Error?) -> Void)?
    )
    func fetchTransactions(_ completion: @escaping ([Transaction]) -> Void)
}
