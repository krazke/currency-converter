//
//  AnyTargetConvertible.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Moya

protocol AnyTargetConvertible {
    var any: AnyTarget { get }
}

extension AnyTargetConvertible where Self: TargetType {
    var any: AnyTarget { .init(target: self) }
}
