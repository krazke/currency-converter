//
//  ExchangeService.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine
import RealmSwift

final class ExchangeService {
    // MARK: - Dependencies
    
    private let networking: NetworkingServiceInterface
    private let database: DatabaseServiceInterface
    
    // MARK: - Properties
    
    var balances: AnyPublisher<[Balance], Never> {
        _balances.eraseToAnyPublisher()
    }
    
    var transactions: AnyPublisher<[Transaction], Never> {
        _transactions.eraseToAnyPublisher()
    }
    
    private let _balances: CurrentValueSubject<[Balance], Never> = .init(.init())
    private let _transactions: CurrentValueSubject<[Transaction], Never> = .init(.init())
    
    // MARK: - Lifecycle
    
    required init(
        networking: NetworkingServiceInterface,
        database: DatabaseServiceInterface
    ) {
        self.networking = networking
        self.database = database
        initializeService()
    }
}

// MARK: - Private

private extension ExchangeService {
    func initializeService() {
        fetchTransactions { [weak self] transactions in
            self?._transactions.send(transactions)
        }
        
        fetchBalances { [weak self] balances in
            self?._balances.send(balances)
            if balances.isEmpty {
                self?.initializeBalances()
            }
        }
    }
    
    func initializeBalances() {
        let initialBalances: [BalanceModel] = [
            .init(
                currency: .eur,
                amount: 1000.0,
                transactionId: nil
            ),
            .init(
                currency: .usd,
                amount: .zero,
                transactionId: nil
            ),
            .init(
                currency: .jpy,
                amount: .zero,
                transactionId: nil
            )
        ]
        initialBalances.forEach { [weak self] balance in
            self?.database.add(balance, completion: { _ in
                self?.updateBalances()
            })
        }
    }
    
    func applySellTransaction(
        _ transaction: Transaction,
        completion: ((Error?) -> Void)?
    ) {
        database.update(
            where: {
                $0.id == transaction.fromCurrency
            }, { (balance: BalanceModel?) in
                balance?.amount -= transaction.fromAmount + transaction.commission
                balance?.transactionId = transaction.id
            }) { [weak self] error in
                if let error: Error = error {
                    self?.performInResponseQueue {
                        completion?(error)
                    }
                    return
                }
                self?.applyBuyTransaction(
                    transaction,
                    completion: completion
                )
            }
    }
    
    func applyBuyTransaction(
        _ transaction: Transaction,
        completion: ((Error?) -> Void)?
    ) {
        database.update(
            where: {
                $0.id == transaction.toCurrency
            }, { (balance: BalanceModel?) in
                balance?.amount += transaction.toAmount
                balance?.transactionId = transaction.id
            }) { [weak self] error in
                if let error: Error = error {
                    self?.performInResponseQueue {
                        completion?(error)
                    }
                    return
                }
                self?.updateBalances()
                self?.performInResponseQueue {
                    completion?(nil)
                }
            }
    }
    
    func updateBalances() {
        fetchBalances { [weak self] balances in
            self?._balances.send(balances)
        }
    }
    
    func fetchBalances(_ completion: @escaping ([Balance]) -> Void) {
        database.getAllMapped(
            mapper: { (balance: BalanceModel) -> Balance in
                    .init(with: balance)
            }) {
                completion($0)
            }
    }
}

// MARK: - ExchangeServiceInterface

extension ExchangeService: ExchangeServiceInterface {
    func exchange(
        _ request: ExchangeRequest,
        _ completion: @escaping (Result<ExchangeResponse, Error>) -> Void
    ) {
        networking.makeRequest(
            ConverterTarget.exchange(request),
            type: ExchangeResponse.self,
            completion: completion
        )
    }
    
    func validateExchange(
        transaction: Transaction,
        _ completion: @escaping (Error?) -> Void
    ) {
        let totalAmount: Float = transaction.fromAmount + transaction.commission
        guard let balance: Balance = _balances.value.first(where: { $0.currency == transaction.fromCurrency }) else {
            performInResponseQueue {
                completion(Errors.unknown)
            }
            return
        }
        performInResponseQueue {
            completion(
                balance.amount >= totalAmount
                ? nil
                : Errors.insufficientFunds(
                    commission: transaction.commission,
                    totalSize: transaction.fromAmount + transaction.commission,
                    currency: transaction.fromCurrency
                )
            )
        }
    }
    
    func add(
        transaction: TransactionModel,
        _ completion: ((Error?) -> Void)?
    ) {
        let _transaction: Transaction = .init(with: transaction)
        database.add(
            transaction,
            completion: { [weak self] error in
                if let error: Error = error {
                    self?.performInResponseQueue {
                        completion?(error)
                    }
                    return
                }
                self?.applySellTransaction(
                    _transaction,
                    completion: completion
                )
            }
        )
    }
    
    func fetchTransactions(_ completion: @escaping ([Transaction]) -> Void) {
        database.getAllMapped(
            mapper: { (transaction: TransactionModel) -> Transaction in
                    .init(with: transaction)
            }) {
                completion($0)
            }
    }
}
