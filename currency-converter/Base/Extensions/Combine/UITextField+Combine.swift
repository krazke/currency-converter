//
//  UITextField+Combine.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        publisher(for: Self.textDidChangeNotification)
            .compactMap { $0.object as? Self }
            .compactMap { $0.text }
            .eraseToAnyPublisher()
    }
}
