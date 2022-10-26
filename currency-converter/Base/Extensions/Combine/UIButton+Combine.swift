//
//  UIButton+Combine.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import Combine
import UIKit

extension UIButton {
    var onTouchInside: AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
