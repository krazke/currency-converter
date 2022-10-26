//
//  BalanceCell.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import SnapKit

final class BalanceCell: UICollectionViewCell {
    // MARK: - UI Elements
    
    private lazy var balanceLabel: UILabel = build {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 17.0, weight: .semibold)
    }
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
}

// MARK: - Public

extension BalanceCell {
    func set(balance: Balance) {
        balanceLabel.text = R.string.localizable.balanceBalance_label(Double(balance.amount), balance.currency)
    }
}

// MARK: - Layout

private extension BalanceCell {
    func addSubviews() {
        contentView.addSubview(balanceLabel)
    }

    func setupConstraints() {
        balanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8.0)
            $0.right.equalToSuperview().inset(8.0)
        }
    }
}
