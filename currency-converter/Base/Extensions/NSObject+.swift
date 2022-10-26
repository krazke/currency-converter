//
//  NSObject+.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import Foundation

extension NSObject {
    static var className: String {
        String(describing: self)
    }

    var className: String {
        type(of: self).className
    }
}
