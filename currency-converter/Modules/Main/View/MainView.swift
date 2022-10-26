//
//  MainView.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine
import SnapKit

private typealias Module = Main
private typealias View = Module.View

extension Module {
    final class View: UIViewController {
        // MARK: - Dependencies
        
        var viewModel: ViewModelInterface!
        var keyboardObserver: KeyboardObserverInterface!
        
        // MARK: - UI Elements
        
        private lazy var contentView: UIView = build { view in
            view.backgroundColor = _contentView.backgroundColor
            view.addSubviews(
                scrollView,
                submitButton
            )
            
            scrollView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            _contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
            
            submitButton.snp.makeConstraints {
                $0.left.equalToSuperview().offset(32.0)
                $0.right.equalToSuperview().inset(32.0)
                $0.bottom.equalToSuperview().inset(24.0)
            }
        }
        
        private lazy var scrollView: UIScrollView = build {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.addSubview(_contentView)
        }
        
        private lazy var _contentView: UIView = build {
            $0.backgroundColor = .systemBackground
            $0.addSubviews(stackView)
            
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        private lazy var stackView: UIStackView = build {
            $0.axis = .vertical
            $0.spacing = 16.0
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        private lazy var balanceView: HeaderedView<BalanceView> = .init(
            title: R.string.localizable.balanceHeader(),
            view: .init()
        )
        
        private lazy var exchangeView: HeaderedView<ExchangeView> = .init(
            title: R.string.localizable.exchangeHeader(),
            view: .init()
        )
        
        private lazy var submitButton: RoundedButton = .init(
            title: R.string.localizable.commonSubmit()
        )
        
        // MARK: - Properties
        
        private var subscriptions: Set<AnyCancellable> = .init()
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            addSubviews()
            setupConstraints()
            setupView()
            setupBindings()
            setupGestures()
            viewModel.didLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            keyboardObserver.startListening()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            keyboardObserver.stopListening()
        }
    }
}

// MARK: - Layout

extension View {
    func addSubviews() {
        view.addSubviews(contentView)
        stackView.addArrangedSubview(balanceView)
        stackView.addArrangedSubview(exchangeView)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupView() {
        navigationItem.title = R.string.localizable.mainTitle()
        view.backgroundColor = contentView.backgroundColor
    }
}

// MARK: - Private

extension View {
    func setupBindings() {
        subscriptions = [
            exchangeView.view.onSellAmountChange
                .sink(receiveValue: { [weak self] in
                    self?.viewModel.sellAmount = $0
                }),
            exchangeView.view.onBuyAmountChange
                .sink(receiveValue: { [weak self] in
                    self?.viewModel.buyAmount = $0
                }),
            exchangeView.view.onSellCurrencyChange
                .compactMap { $0 }
                .sink(receiveValue: { [weak self] in
                    self?.viewModel.sellCurrency = $0
                }),
            exchangeView.view.onBuyCurrencyChange
                .compactMap { $0 }
                .sink(receiveValue: { [weak self] in
                    self?.viewModel.buyCurrency = $0
                }),
            submitButton.onTouchInside
                .sink(receiveValue: { [weak self] in
                    self?.viewModel.didTouchSubmit()
                }),
            keyboardObserver.onKeyboardEvent
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] in
                    self?.handleKeyboardEvent(with: $0)
                })
        ]
    }
    
    func setupGestures() {
        let tapGesture: UITapGestureRecognizer = .init(
            target: self,
            action: #selector(handleTapGesture)
        )
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - ViewInterface

extension View: Module.ViewInterface {
    func display(balances: [Balance]) {
        balanceView.view.set(balances: balances)
        exchangeView.view.set(currencies: balances.map(\.currency))
    }
    
    func display(
        amount: Float,
        commission: Float,
        isSell: Bool
    ) {
        exchangeView.view.display(
            amount: amount,
            isSell: isSell
        )
        
        if commission.isZero {
            if viewModel.buyAmount?.isZero == true
                || viewModel.sellAmount?.isZero == true {
                exchangeView.setFooterText(nil)
            } else {
                exchangeView.setFooterText(R.string.localizable.mainCommission_messageFree())
            }
        } else {
            exchangeView.setFooterText(R.string.localizable.mainCommission_messageSome(Double(commission)))
        }
    }
    
    func display(error: String) {
        exchangeView.setFooterText(
            error,
            textColor: .systemRed,
            isBounced: true
        )
    }
    
    func showAlert(
        title: String?,
        message: String?
    ) {
        let alert: UIAlertController = .init(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: R.string.localizable.commonOk(), style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Private

private extension View {
    func handleKeyboardEvent(with parameters: KeyboardParameters) {
        var animations: () -> Void = {}
        let completion: ((Bool) -> Void)? = nil

        switch parameters.state {
        case .willShow:
            scrollView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(parameters.rect.height)
            }
            
            submitButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(24.0 + parameters.rect.height)
            }

            animations = {
                self.contentView.layoutIfNeeded()
            }
        case .willHide:
            scrollView.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            
            submitButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(24.0)
            }

            animations = {
                self.contentView.layoutIfNeeded()
            }
        default:
            break
        }

        UIView.animate(
            withDuration: parameters.animationTime,
            delay: .zero,
            options: .init(rawValue: parameters.animationCurve),
            animations: animations,
            completion: completion
        )
    }
    
    @objc
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
