//
//  ExchangeResponse.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

struct ExchangeResponse: Codable {
    let amount: Float
    let currency: Currency
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let amountString: String = try? container.decode(Currency.self, forKey: .amount),
           let _amount: Float = .init(amountString) {
            amount = _amount
        } else {
            amount = try container.decode(Float.self, forKey: .amount)
        }
        currency = try container.decode(Currency.self, forKey: .currency)
    }
}
