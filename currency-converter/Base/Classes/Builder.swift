//
//  Builder.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

// MARK: - Base

func build<T>(
    _ object: T,
    _ builder: (T) -> Void
) -> T {
    builder(object)
    return object
}

// MARK: - UIView

func build<T: UIView>(_ builder: (T) -> Void) -> T {
    build(T(), builder)
}
