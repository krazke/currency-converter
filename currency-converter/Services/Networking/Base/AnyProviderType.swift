//
//  AnyProviderType.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Moya

protocol AnyProviderType: TargetType {
    var apiDomain: String { get }
}

extension AnyProviderType {
    var baseURL: URL {
        getBaseURL()
    }

    var apiDomain: String {
        .init()
    }

    var sampleData: Data {
        "{}".data(using: String.Encoding.utf8)!
    }

    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
        case .post, .patch, .put:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }

    var headers: [String: String]? {
        [:]
    }

    var task: Task {
        .requestPlain
    }

    private var encoder: JSONEncoder {
        build(.init()) {
            $0.keyEncodingStrategy = .convertToSnakeCase
            $0.outputFormatting = .prettyPrinted
        }
    }
}

// MARK: - Private

private extension AnyProviderType {
    func getBaseURL() -> URL {
        NetworkingConfiguration.current.apiURL.appendingPathComponent(apiDomain)
    }
}

