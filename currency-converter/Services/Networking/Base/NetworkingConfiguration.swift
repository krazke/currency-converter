//
//  NetworkingConfiguration.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Foundation

enum NetworkingConfiguration {
    // MARK: - Subtypes

    enum Mode {
        case staging
        case production
    }

    struct Configuration {
        let apiURL: URL
    }

    // MARK: - Properties

    static var mode: Mode = .staging {
        didSet {
            switch mode {
            case .staging:
                current = buildStagingConfiguration()
            case .production:
                current = buildProductionConfiguration()
            }
        }
    }

    static var current: Configuration!
}

// MARK: - Private

private extension NetworkingConfiguration {
    static func buildStagingConfiguration() -> Configuration {
        .init(
            apiURL: URL(string: "http://api.evp.lt/")!
        )
    }

    static func buildProductionConfiguration() -> Configuration {
        .init(
            apiURL: URL(string: "http://api.evp.lt/")!
        )
    }
}
