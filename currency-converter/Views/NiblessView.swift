//
//  NiblessView.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

internal class NiblessView: UIView {
    // MARK: - Lifecycle

    @available(
        *,
        unavailable,
        message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }

    init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        setupView()
    }

    // MARK: - Layout

    func addSubviews() {}
    func setupConstraints() {}
    func setupView() {}
}
