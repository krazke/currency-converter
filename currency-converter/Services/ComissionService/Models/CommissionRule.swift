//
//  CommissionRule.swift
//  currency-converter
//
//  Created by krazke on 26.10.2022.
//

enum CommissionRule {
    // Every 'x' transaction is free
    case xTransaction(Int)
    // Every transaction with specific currency and up to specific amount is free
    case xCurrencyAmount(currency: String, amount: Float)
    // First 'x' transactions is free
    case firstXTransactions(Int)
    
    func validate(_ ticket: TransactionTicket) -> Bool {
        switch self {
        case let .xTransaction(transactionIndex):
            return ticket.userInfo.previousTransactions.count + 1 % transactionIndex == .zero
        case let .xCurrencyAmount(currency, amount):
            return ticket.transaction.fromCurrency == currency
            && ticket.transaction.fromAmount <= amount
        case let .firstXTransactions(transactionsCount):
            return ticket.userInfo.previousTransactions.count <= transactionsCount
        }
    }
}
