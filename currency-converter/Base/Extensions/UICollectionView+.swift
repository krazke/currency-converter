//
//  UICollectionView+.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(
            T.self,
            forCellWithReuseIdentifier: T.defaultReuseIdentifier
        )
    }

    func dequeReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.defaultReuseIdentifier,
            for: indexPath
        ) as? T else {
            preconditionFailure("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

