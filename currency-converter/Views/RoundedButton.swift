//
//  RoundedButton.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import UIKit

internal class RoundedButton: UIButton {
    // MARK: - Properties
    
    private let height: CGFloat
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        title: String,
        height: CGFloat = 50.0
    ) {
        self.height = height
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupButton()
    }
}

// MARK: - Layout

private extension RoundedButton {
    func setupButton() {
        titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
        layer.cornerRadius = height / 2.0
        
        backgroundColor = .systemBlue
        
        snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
}
