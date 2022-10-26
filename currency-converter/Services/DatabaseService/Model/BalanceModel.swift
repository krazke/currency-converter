//
//  BalanceModel.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import RealmSwift

final class BalanceModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var amount: Float
    @Persisted var transactionId: Int?
    
    convenience init(
        currency: Currency,
        amount: Float,
        transactionId: Int?
    ) {
        self.init()
        self.id = currency
        self.amount = amount
        self.transactionId = transactionId
    }
}

struct Balance {
    let currency: Currency
    let amount: Float
    let transactionId: Int?
    
    init(with balance: BalanceModel) {
        self.currency = balance.id
        self.amount = balance.amount
        self.transactionId = balance.transactionId
    }
}
