//
//  ExchangeView+Row.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine
import DropDown
import SnapKit

extension ExchangeView {
    final class Row: NiblessView {
        // MARK: - UI Elements
        
        private lazy var imageView: UIImageView = build {
            $0.contentMode = .scaleAspectFit
            $0.snp.makeConstraints {
                $0.size.equalTo(40.0)
            }
        }
        
        private lazy var titleLabel: UILabel = build {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 17.0, weight: .semibold)
        }
        
        private lazy var textField: UITextField = build {
            $0.placeholder = R.string.localizable.exchangeAmount_placeholder()
            $0.textAlignment = .right
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 17.0, weight: .semibold)
            $0.autocorrectionType = .no
            let locale: String = Locale.current.identifier
            if (locale == "en_GB" || locale == "en_US") {
                $0.keyboardType = .decimalPad
            } else {
                $0.keyboardType = .numbersAndPunctuation
            }
            $0.snp.makeConstraints {
                $0.height.equalTo(32.0)
            }
        }
        
        private lazy var currencyDropDown: DropDown = build {
            $0.anchorView = currencyView
            $0.bottomOffset = .init(
                x: .zero,
                y: CurrencyView.height
            )
            $0.willShowAction = { [weak self] in
                self?.superview?.endEditing(true)
            }
            $0.selectionAction = { [weak self] _, currency in
                self?.selectedCurrency = currency
            }
        }
        
        private lazy var currencyView: CurrencyView = .init()
        
        private lazy var separatorView: UIView = build {
            $0.backgroundColor = .lightGray
            $0.snp.makeConstraints {
                $0.height.equalTo(1.0 / UIScreen.main.scale)
            }
        }
        
        // MARK: - Properties
        
        private(set) var selectedCurrency: Currency = .usd {
            didSet {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.currencyView.set(currency: self.selectedCurrency)
                    self.didSelectCurrency?(self.selectedCurrency)
                }
            }
        }
        
        var didSelectCurrency: ((Currency) -> Void)?
        var didChangeAmount: ((Float) -> Void)?
        
        private var subscriptions: Set<AnyCancellable> = .init()
        
        // MARK: - Lifecycle
        
        init(
            image: UIImage?,
            title: String
        ) {
            super.init()
            setupBindings()
            imageView.image = image
            titleLabel.text = title
            set(amount: .zero)
        }
        
        deinit {
            didSelectCurrency = nil
            didChangeAmount = nil
        }
        
        // MARK: - Overridings
        
        override func addSubviews() {
            super.addSubviews()
            
            addSubviews(
                imageView,
                titleLabel,
                textField,
                currencyView,
                separatorView
            )
        }
        
        override func setupConstraints() {
            super.setupConstraints()
            
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16.0)
                $0.left.equalToSuperview()
                $0.bottom.equalToSuperview().inset(16.0)
            }
            
            titleLabel.snp.makeConstraints {
                $0.centerY.equalTo(imageView)
                $0.left.equalTo(imageView.snp.right).offset(16.0)
                $0.right.equalTo(textField.snp.left).offset(-8.0)
            }
            
            textField.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.right.equalTo(currencyView.snp.left).offset(-8.0)
            }
            
            currencyView.snp.makeConstraints {
                $0.centerY.equalTo(textField)
                $0.right.equalToSuperview()
            }
            
            separatorView.snp.makeConstraints {
                $0.bottom.right.equalToSuperview()
                $0.left.equalTo(imageView.snp.right).offset(16.0)
            }
        }
    }
}

// MARK: - Public

extension ExchangeView.Row {
    func set(
        currencies: [Currency],
        initialCurrency: String
    ) {
        selectedCurrency = initialCurrency
        currencyDropDown.dataSource = currencies
        let index: Int = currencies.firstIndex(of: initialCurrency) ?? .zero
        currencyDropDown.selectRow(at: index)
    }
    
    func set(amount: Float) {
        textField.text = R.string.localizable.exchangeAmount(Double(amount))
    }
}

// MARK: - Private

private extension ExchangeView.Row {
    func setupBindings() {
        subscriptions = [
            currencyView.onTouch
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] in
                    self?.currencyDropDown.show()
                }),
            textField.textPublisher
                .receive(on: DispatchQueue.main)
                .debounce(for: 0.3, scheduler: DispatchQueue.main)
                .compactMap { Float($0) }
                .sink(receiveValue: { [weak self] in
                    self?.didChangeAmount?($0)
                })
        ]
    }
}
