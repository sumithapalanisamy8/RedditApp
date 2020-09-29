//
//  NetworkAdapter.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import Foundation
import Combine

enum NetworkError: Error {
    case noData
    case invalidURL
}

class NetworkAdapter: NSObject, URLSessionDelegate {
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        let publisher = self.session.dataTaskPublisher(for: request)
        return publisher.map(\.data)
            .decode(type: T.self, decoder: JSONDecoder()).eraseToAnyPublisher()
    }
}
