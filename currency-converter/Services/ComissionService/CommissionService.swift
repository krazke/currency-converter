//
//  CommissionService.swift
//  currency-converter
//
//  Created by krazke on 24.10.2022.
//

import Foundation

final class CommissionService {
    // MARK: - Dependencies
    
    private let exchangeService: ExchangeServiceInterface
    
    // MARK: - Properties
    
    private let commissionRules: [CommissionRule] = [
        .firstXTransactions(5),
        .xCurrencyAmount(currency: .eur, amount: 200.0),
        .xTransaction(10)
    ]
    
    private let commission: Float = 0.07
    
    // MARK: - Lifecycle
    
    required init(exchangeService: ExchangeServiceInterface) {
        self.exchangeService = exchangeService
    }
}

// MARK: - Interface

extension CommissionService: CommissionServiceInterface {
    func appendCommission(
        to transaction: Transaction,
        _ completion: @escaping (Result<Transaction, Error>) -> Void
    ) {
        exchangeService.fetchTransactions { [weak self] transactions in
            guard let self = self else {
                self?.performInResponseQueue {
                    completion(.failure(Errors.unknown))
                }
                return
            }
            var ticket: TransactionTicket = .init(
                transaction: transaction,
                userInfo: .init(
                    previousTransactions: transactions
                )
            )
            ticket.validate(
                commissionRules: self.commissionRules,
                commission: self.commission
            )
            self.performInResponseQueue {
                completion(.success(ticket.transaction))
            }
        }
    }
}
