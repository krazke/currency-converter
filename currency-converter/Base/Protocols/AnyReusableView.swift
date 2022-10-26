//
//  AnyReusableView.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import UIKit

protocol AnyReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension AnyReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        className
    }
}

extension UITableViewCell: AnyReusableView {}
extension UITableViewHeaderFooterView: AnyReusableView {}
extension UICollectionReusableView: AnyReusableView {}
