//
//  AnyTarget.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Moya

final class AnyTarget: AnyProviderType {
    // MARK: - Properties

    let target: TargetType
    var baseURL: URL { target.baseURL }
    var apiDomain: String { .init() }
    var path: String { target.path }
    var sampleData: Data { target.sampleData }
    var task: Task { target.task }
    var method: Moya.Method { target.method }
    var headers: [String: String]? { target.headers }

    // MARK: - Lifecycle

    init(target: TargetType) {
        self.target = target
    }
}

// MARK: - Equatable

extension AnyTarget: Equatable {
    static func == (lhs: AnyTarget, rhs: AnyTarget) -> Bool {
        func hash(from object: AnyTarget) -> String {
            object.apiDomain + object.path + (object.headers ?? [:]).map(\.value).reduce(.init(), +)
        }
        return hash(from: lhs) == hash(from: rhs)
    }
}

// MARK: - Hashable

extension AnyTarget: Hashable {
    func hash(into hasher: inout Hasher) {
        func string(from dict: [String: Any]) -> String {
            dict
                .sorted(by: { $0.key < $1.key })
                .map { "\($0.0)\($0.1)" }
                .reduce("", +)
        }

        func string(from data: [MultipartFormData]) -> String {
            data
                .sorted(by: { $0.name < $1.name })
                .map { "\($0.name)\($0.fileName ?? "")\($0.mimeType ?? "")" }
                .reduce("", +)
        }

        func string(from data: Encodable?) -> String {
            guard let data: Encodable = data,
                  let obj: NSObject = data as? NSObject
            else { return .init() }
            return "\(obj.hashValue)"
        }

        guard let target: AnyProviderType = target as? AnyProviderType else { return }

        hasher.combine(target.apiDomain)
        hasher.combine(target.path)
        hasher.combine(string(from: target.headers ?? [:]))
    }
}
