//
//  HeaderedView.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import SnapKit

final class HeaderedView<T: UIView>: NiblessView {
    // MARK: - UI Elements
    
    private(set) var view: T
    private lazy var headerLabel: UILabel = build {
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 15.0, weight: .semibold)
    }
    
    private lazy var footerLabel: UILabel = build {
        $0.font = .systemFont(ofSize: 13.0, weight: .light)
        $0.textColor = .tertiaryLabel
        $0.textAlignment = .center
        $0.numberOfLines = .zero
        $0.alpha = .zero
    }
    
    // MARK: - Lifecycle

    required init(
        title: String,
        view: T
    ) {
        self.view = view
        super.init()
        self.headerLabel.text = title
    }
    
    // MARK: - Overridings
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(
            headerLabel,
            view,
            footerLabel
        )
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16.0)
            $0.right.equalToSuperview().inset(8.0)
        }
        
        view.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(8.0)
            $0.left.equalToSuperview().offset(8.0)
            $0.right.equalToSuperview().inset(8.0)
        }
        
        footerLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(8.0)
            $0.left.equalToSuperview().offset(16.0)
            $0.right.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        view.layer.cornerRadius = 8.0
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1.0 / UIScreen.main.scale
    }
}

// MARK: - Public

extension HeaderedView {
    func setFooterText(
        _ text: String?,
        textColor: UIColor = .secondaryLabel,
        isBounced: Bool = false
    ) {
        footerLabel.text = text
        footerLabel.textColor = textColor
        
        UIView.animate(withDuration: 0.3) {
            self.footerLabel.alpha = text != nil ? 1.0 : .zero
        } completion: { _ in
            guard isBounced else { return }
            UIView.animate(withDuration: 0.3) {
                self.footerLabel.transform = CGAffineTransformScale(self.footerLabel.transform, 1.1, 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.footerLabel.transform = .identity
                }
            }
        }
    }
}
