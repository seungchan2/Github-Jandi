//
//  APIService.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Combine
import Foundation

public protocol RequestType {
    func request(_ request: NetworkRequest) -> AnyPublisher<Data, APIError>
}

public final class APIService: RequestType {
    
    public init() {}
    public func request(_ request: NetworkRequest) -> AnyPublisher<Data, APIError> {
        guard let url = URL(string: request.url) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { _ in .requestFailed }
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
