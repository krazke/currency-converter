//
//  BalanceView.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import SnapKit

final class BalanceView: NiblessView {
    // MARK: UI Elements
    
    private lazy var collectionView: UICollectionView = build(
        .init(
            frame: .zero,
            collectionViewLayout: layout
        )
    ) {
        $0.dataSource = self
        $0.register(BalanceCell.self)
    }
    
    // MARK: - Properties
    
    private let layout: UICollectionViewFlowLayout = build(.init()) {
        $0.estimatedItemSize = .init(
            width: 80.0,
            height: 80.0
        )
        $0.minimumLineSpacing = .zero
        $0.minimumInteritemSpacing = .zero
        $0.scrollDirection = .horizontal
    }
    
    private var balances: [Balance] = .init() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Overridings
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(80.0)
        }
    }
    
    override func setupView() {
        super.setupView()
        clipsToBounds = true
    }
}

// MARK: - Public

extension BalanceView {
    func set(balances: [Balance]) {
        self.balances = balances
    }
}

// MARK: - UICollectionViewDataSource

extension BalanceView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        balances.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: BalanceCell = collectionView.dequeReusableCell(for: indexPath)
        if let item: Balance = balances[safe: indexPath.row] {
            cell.set(balance: item)
        }
        return cell
    }
}
