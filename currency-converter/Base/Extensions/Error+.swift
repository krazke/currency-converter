//
//  Error+.swift
//  currency-converter
//
//  Created by krazke on 24.10.2022.
//

import Foundation

enum Errors: LocalizedError {
    case unknown
    case insufficientFunds(commission: Float, totalSize: Float, currency: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return R.string.localizable.errorUnknown()
        case let .insufficientFunds(commission, totalSize, currency):
            var message: String = R.string.localizable.errorInsufficient_funds(Double(totalSize), currency)
            if !commission.isZero {
                message.append(R.string.localizable.errorInsufficient_fundsCommission(Double(commission), currency))
            }
            return message
        }
    }
}
