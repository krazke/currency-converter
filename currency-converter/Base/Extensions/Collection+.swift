//
//  Collection+.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        if distance(to: index) >= .zero,
           distance(from: index) > .zero {
            return self[index]
        }
        return nil
    }

    subscript(safe bounds: Range<Index>) -> SubSequence? {
        if distance(to: bounds.lowerBound) >= .zero,
           distance(from: bounds.upperBound) >= .zero {
            return self[bounds]
        }
        return nil
    }

    subscript(safe bounds: ClosedRange<Index>) -> SubSequence? {
        if distance(to: bounds.lowerBound) >= .zero,
           distance(from: bounds.upperBound) > .zero {
            return self[bounds]
        }
        return nil
    }
}

private extension Collection {
    func distance(from startIndex: Index) -> Int {
        distance(
            from: startIndex,
            to: self.endIndex
        )
    }

    func distance(to endIndex: Index) -> Int {
        distance(
            from: self.startIndex,
            to: endIndex
        )
    }
}
