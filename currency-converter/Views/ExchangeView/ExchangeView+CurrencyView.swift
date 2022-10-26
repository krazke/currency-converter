//
//  ExchangeView+CurrencyView.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import Combine
import SnapKit

extension ExchangeView {
    final class CurrencyView: NiblessView {
        // MARK: - UI Elements
        
        private lazy var currencyLabel: UILabel = build {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 17.0, weight: .semibold)
        }
        
        private lazy var imageView: UIImageView = build {
            $0.contentMode = .scaleAspectFit
            $0.image = R.image.arrow_right()
            $0.snp.makeConstraints {
                $0.size.equalTo(16.0)
            }
        }
        
        private lazy var phantomButton: UIButton = .init()
        
        // MARK: - Properties
        
        static var height: CGFloat = 42.0
        
        var onTouch: AnyPublisher<Void, Never> {
            phantomButton.onTouchInside
        }
        
        // MARK: - Overridings
        
        override func addSubviews() {
            super.addSubviews()
            addSubviews(
                currencyLabel,
                imageView,
                phantomButton
            )
        }
        
        override func setupConstraints() {
            super.setupConstraints()
            currencyLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(8.0)
            }
            
            imageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(currencyLabel.snp.right).offset(4.0)
                $0.right.equalToSuperview().inset(8.0)
            }
            
            phantomButton.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            snp.makeConstraints {
                $0.height.equalTo(Self.height)
                $0.width.equalTo(80.0)
            }
        }
    }
}

// MARK: - Public

extension ExchangeView.CurrencyView {
    func set(currency: Currency) {
        currencyLabel.text = currency
    }
}
