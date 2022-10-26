//
//  NetworkingService.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Alamofire
import Combine
import Moya

final class NetworkingService {
    // MARK: - Properties

    private lazy var provider: MoyaProvider<AnyTarget> = buildProvider()
    private let decoder: JSONDecoder = build(.init()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
}

// MARK: - NetworkingServiceInterface

extension NetworkingService: NetworkingServiceInterface {
    @discardableResult
    func makeRequest<T: Decodable>(
        _ target: AnyTargetConvertible,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Moya.Cancellable? {
        makeAnyRequest(
            target,
            type: type,
            completion: completion
        )
    }
}

// MARK: - Private

private extension NetworkingService {
    func buildSessionConfiguration() -> URLSessionConfiguration {
        build(.default) {
            $0.headers = .default
            $0.timeoutIntervalForRequest = 30.0
            $0.timeoutIntervalForResource = 30.0
            $0.requestCachePolicy = .useProtocolCachePolicy
        }
    }

    func buildProvider() -> MoyaProvider<AnyTarget> {
        #if DEBUG
        let plugins: [PluginType] = [
            NetworkLoggerPlugin()
        ]
        #else
        let plugins: [PluginType] = .init()
        #endif
        
        let session: Session = .init(
            configuration: buildSessionConfiguration()
        )

        return .init(
            callbackQueue: responseQueue,
            session: session,
            plugins: plugins
        )
    }

    @discardableResult
    func makeAnyRequest<T: Decodable>(
        _ target: AnyTargetConvertible,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Moya.Cancellable? {
        provider.request(
                target.any,
                completion: { [unowned self] result in
                    switch result {
                    case let .success(response):
                        do {
                            let data: T = try decoder.decode(T.self, from: response.data)
                            completion(.success(data))
                        } catch {
                            completion(.failure(error))
                        }
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            )
    }
}
