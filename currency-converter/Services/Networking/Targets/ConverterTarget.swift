//
//  ConverterTarget.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Moya

enum ConverterTarget {
    case exchange(ExchangeRequest)
}

// MARK: - AnyProviderType

extension ConverterTarget: AnyProviderType, AnyTargetConvertible {
    var apiDomain: String {
        switch self {
        case .exchange:
            return "currency/commercial/exchange"
        }
    }

    var path: String {
        switch self {
        case let .exchange(request):
            return "\(request.amount)-\(request.from)/\(request.to)/latest"
        }
    }

    var method: Method {
        switch self {
        case .exchange:
            return .get
        }
    }
}

