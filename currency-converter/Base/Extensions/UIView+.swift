//
//  UIView+.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
    
    func superview<T>(of type: T.Type) -> T? {
        superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
    }
}
