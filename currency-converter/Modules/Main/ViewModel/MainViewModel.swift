//
//  MainViewModel.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine
import Foundation

private typealias Module = Main
private typealias ViewModel = Module.ViewModel

extension Module {
    final class ViewModel {
        // MARK: - Dependencies
        
        weak var view: ViewInterface!
        private let exchangeService: ExchangeServiceInterface
        private let commissionService: CommissionServiceInterface
        
        // MARK: - Properties
        
        var sellAmount: Float? {
            didSet {
                handleAmountChange(
                    sellAmount,
                    currencyFrom: sellCurrency,
                    currencyTo: buyCurrency,
                    isSell: true
                )
            }
        }
        
        var sellCurrency: String? {
            didSet {
                handleAmountChange(
                    sellAmount,
                    currencyFrom: sellCurrency,
                    currencyTo: buyCurrency,
                    isSell: true
                )
            }
        }
        
        var buyAmount: Float? {
            didSet {
                handleAmountChange(
                    buyAmount,
                    currencyFrom: buyCurrency,
                    currencyTo: sellCurrency,
                    isSell: false
                )
            }
        }
        
        var buyCurrency: String? {
            didSet {
                handleAmountChange(
                    buyAmount,
                    currencyFrom: buyCurrency,
                    currencyTo: sellCurrency,
                    isSell: false
                )
            }
        }
        
        private var commission: Float = .zero
        private var isHandleNeeded: Bool = true
        private var subscriptions: Set<AnyCancellable> = .init()
        
        // MARK: - Lifecycle
        
        required init(
            exchangeService: ExchangeServiceInterface,
            commissionService: CommissionServiceInterface
        ) {
            self.exchangeService = exchangeService
            self.commissionService = commissionService
            setupBindings()
        }
    }
}

// MARK: - Private

private extension ViewModel {
    func setupBindings() {
        subscriptions = [
            exchangeService.balances
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] balances in
                    self?.view.display(
                        balances: balances.sorted(by: { $0.amount > $1.amount })
                    )
                })
        ]
    }
    
    func makeTransaction() -> Transaction? {
        guard let sellAmount: Float = sellAmount,
              let sellCurrency: String = sellCurrency,
              let buyAmount: Float = buyAmount,
              let buyCurrency: String = buyCurrency,
              !sellAmount.isZero,
              !buyAmount.isZero
        else { return nil }
        return .init(
            fromCurrency: sellCurrency,
            fromAmount: sellAmount,
            toCurrency: buyCurrency,
            toAmount: buyAmount,
            commission: commission
        )
    }
    
    func handleAmountChange(
        _ amount: Float?,
        currencyFrom: String?,
        currencyTo: String?,
        isSell: Bool
    ) {
        guard isHandleNeeded,
              let amount: Float = amount,
              let currencyFrom: String = currencyFrom,
              let currencyTo: String = currencyTo,
              currencyFrom != currencyTo
        else { return }
        
        isHandleNeeded = false
        let request: ExchangeRequest = .init(
            from: currencyFrom,
            to: currencyTo,
            amount: amount
        )
        exchangeService.exchange(request) { [weak self] result in
            switch result {
            case let .success(response):
                let transaction: Transaction = .init(
                    fromCurrency: currencyFrom,
                    fromAmount: amount,
                    toCurrency: currencyTo,
                    toAmount: response.amount
                )
                
                if isSell {
                    self?.buyAmount = transaction.toAmount
                } else {
                    self?.sellAmount = transaction.toAmount
                }
                
                self?.commissionService.appendCommission(to: transaction) { result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(transaction):
                        self.isHandleNeeded = true
                        self.commission = transaction.commission
                        
                        guard let _transaction: Transaction = self.makeTransaction() else { return }
                        
                        self.exchangeService.validateExchange(
                            transaction: _transaction
                        ) { [weak self] error in
                            self?.view.display(
                                amount: transaction.toAmount,
                                commission: transaction.commission,
                                isSell: !isSell
                            )
                            if let error: Error = error {
                                self?.view.display(error: error.localizedDescription)
                            }
                        }
                        
                    case let .failure(error):
                        self.isHandleNeeded = true
                        self.view.display(error: error.localizedDescription)
                    }
                }
                
            case let .failure(error):
                self?.isHandleNeeded = true
                self?.view.display(error: error.localizedDescription)
            }
        }
    }
}

// MARK: - ViewModelInterface

extension ViewModel: Module.ViewModelInterface {
    func didLoad() {}
    
    func didTouchSubmit() {
        guard let transaction: Transaction = makeTransaction() else {
            if sellAmount == .zero {
                view.display(error: R.string.localizable.errorEmpty_sell_amount())
            }
            return
        }
        exchangeService.validateExchange(transaction: transaction) { [weak self] error in
            if let error: Error = error {
                self?.view.display(error: error.localizedDescription)
                return
            }
            
            let _transaction: TransactionModel = .init(with: transaction)
            self?.exchangeService.add(transaction: _transaction) { error in
                if error != nil {
                    self?.view.showAlert(
                        title: R.string.localizable.commonError(),
                        message: R.string.localizable.errorUnknown()
                    )
                    return
                }
                self?.view.showAlert(
                    title: R.string.localizable.commonSucces(),
                    message: R.string.localizable.mainSuccess_message(
                        Double(transaction.fromAmount),
                        transaction.fromCurrency,
                        Double(transaction.toAmount),
                        transaction.toCurrency,
                        Double(transaction.commission),
                        transaction.fromCurrency
                    )
                )
            }
        }
    }
}
