//
//  ExchangeView.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine
import SnapKit

final class ExchangeView: NiblessView {
    // MARK: - UI Elements
    
    private lazy var sellRow: Row = build(
        .init(
            image: R.image.sell_icon(),
            title: R.string.localizable.exchangeSell_title()
        )
    ) {
        $0.didChangeAmount = { [weak self] amount in
            self?.sellAmount.send(amount)
        }
        
        $0.didSelectCurrency = { [weak self] currency in
            guard let self = self else { return }
            if currency == self.buyCurrency.value {
                self.buyCurrency.value = self.sellCurrency.value
                self.buyRow.set(
                    currencies: self.currencies,
                    initialCurrency: self.buyCurrency.value!
                )
            }
            self.sellCurrency.send(currency)
        }
    }
    
    private lazy var buyRow: Row = build(
        .init(
            image: R.image.buy_icon(),
            title: R.string.localizable.exchangeBuy_title()
        )
    ) {
        $0.didChangeAmount = { [weak self] amount in
            self?.buyAmount.send(amount)
        }
        
        $0.didSelectCurrency = { [weak self] currency in
            guard let self = self else { return }
            if currency == self.sellCurrency.value {
                self.sellCurrency.value = self.buyCurrency.value
                self.sellRow.set(
                    currencies: self.currencies,
                    initialCurrency: self.sellCurrency.value!
                )
            }
            self.buyCurrency.send(currency)
        }
    }
    
    // MARK: - Properties
    
    var onSellAmountChange: AnyPublisher<Float, Never> {
        sellAmount.eraseToAnyPublisher()
    }
    
    var onSellCurrencyChange: AnyPublisher<String?, Never> {
        sellCurrency.eraseToAnyPublisher()
    }
    
    var onBuyAmountChange: AnyPublisher<Float, Never> {
        buyAmount.eraseToAnyPublisher()
    }
    
    var onBuyCurrencyChange: AnyPublisher<String?, Never> {
        buyCurrency.eraseToAnyPublisher()
    }
    
    private let sellAmount: CurrentValueSubject<Float, Never> = .init(.zero)
    private let sellCurrency: CurrentValueSubject<String?, Never> = .init(nil)
    private let buyAmount: CurrentValueSubject<Float, Never> = .init(.zero)
    private let buyCurrency: CurrentValueSubject<String?, Never> = .init(nil)
    
    private var currencies: [String] = .init()
    
    // MARK: - Overridings
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(
            sellRow,
            buyRow
        )
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        sellRow.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16.0)
            $0.right.equalToSuperview().inset(16.0)
        }
        
        buyRow.snp.makeConstraints {
            $0.top.equalTo(sellRow.snp.bottom)
            $0.left.equalToSuperview().offset(16.0)
            $0.right.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Public

extension ExchangeView {
    func set(currencies: [Currency]) {
        self.currencies = currencies
        guard let initialSellCurrency: Currency = currencies[safe: 0],
              let initialBuyCurrency: Currency = currencies[safe: 1]
        else { return }
        
        sellCurrency.send(initialSellCurrency)
        buyCurrency.send(initialBuyCurrency)
        sellRow.set(
            currencies: currencies,
            initialCurrency: initialSellCurrency
        )
        buyRow.set(
            currencies: currencies,
            initialCurrency: initialBuyCurrency
        )
    }
    
    func display(
        amount: Float,
        isSell: Bool
    ) {
        if isSell {
            sellRow.set(amount: amount)
        } else {
            buyRow.set(amount: amount)
        }
    }
}
