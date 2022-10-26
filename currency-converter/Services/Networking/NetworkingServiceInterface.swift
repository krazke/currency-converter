//
//  NetworkingServiceInterface.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Moya

protocol NetworkingServiceInterface: AnyService {
    @discardableResult
    func makeRequest<T: Decodable>(
        _ target: AnyTargetConvertible,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Moya.Cancellable?
}
