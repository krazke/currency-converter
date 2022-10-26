//
//  TransactionModel.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import RealmSwift

final class TransactionModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var fromCurrency: Currency
    @Persisted var fromAmount: Float
    @Persisted var toCurrency: Currency
    @Persisted var toAmount: Float
    @Persisted var commission: Float
    
    convenience init(
        fromCurrency: Currency,
        fromAmount: Float,
        toCurrency: Currency,
        toAmount: Float,
        commission: Float
    ) {
        self.init()
        self.id = generateTransactionId()
        self.fromCurrency = fromCurrency
        self.fromAmount = fromAmount
        self.toCurrency = toCurrency
        self.toAmount = toAmount
        self.commission = commission
    }
    
    convenience init(with transaction: Transaction) {
        self.init()
        self.id = transaction.id
        self.fromCurrency = transaction.fromCurrency
        self.fromAmount = transaction.fromAmount
        self.toCurrency = transaction.toCurrency
        self.toAmount = transaction.toAmount
        self.commission = transaction.commission
    }
}

struct Transaction {
    let id: Int
    let fromCurrency: Currency
    let fromAmount: Float
    let toCurrency: Currency
    let toAmount: Float
    var commission: Float
    
    init(with transaction: TransactionModel) {
        self.id = transaction.id
        self.fromCurrency = transaction.fromCurrency
        self.fromAmount = transaction.fromAmount
        self.toCurrency = transaction.toCurrency
        self.toAmount = transaction.toAmount
        self.commission = transaction.commission
    }
    
    init(
        id: Int = generateTransactionId(),
        fromCurrency: Currency,
        fromAmount: Float,
        toCurrency: Currency,
        toAmount: Float,
        commission: Float = .zero
    ) {
        self.id = id
        self.fromCurrency = fromCurrency
        self.fromAmount = fromAmount
        self.toCurrency = toCurrency
        self.toAmount = toAmount
        self.commission = commission
    }
    
    mutating func set(commission: Float) {
        self.commission = commission
    }
}

fileprivate func generateTransactionId() -> Int {
    Int(Date().timeIntervalSince1970 * 1000.0)
}
