//
//  TransactionTicket.swift
//  currency-converter
//
//  Created by krazke on 26.10.2022.
//

struct TransactionTicket {
    struct UserInfo {
        let previousTransactions: [Transaction]
    }
    var transaction: Transaction
    let userInfo: UserInfo
    
    mutating func validate(
        commissionRules: [CommissionRule],
        commission: Float
    ) {
        let rulesCount: Int = commissionRules.count
        for i in .zero ..< rulesCount {
            let rule: CommissionRule = commissionRules[i]
            if rule.validate(self) {
                transaction.set(commission: .zero)
                return
            }
        }
        transaction.set(commission: transaction.fromAmount * commission)
    }
}
