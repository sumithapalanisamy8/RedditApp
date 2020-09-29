//
//  APIService.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import Foundation
import UIKit
import Combine

class APIService: ObservableObject {
    var network: NetworkAdapter
    var afterLink: String = ""
    init(_ adapter: NetworkAdapter = NetworkAdapter()) {
        self.network = adapter
    }
    
    func getPostsList(pagination: Bool) -> AnyPublisher<[Post], Error> {
        let resourceString = pagination ? "http://www.reddit.com/.json?after=\(afterLink)" : "http://www.reddit.com/.json"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        let request = URLRequest(url: resourceURL)
        let future = network.request(request).map({ (result: Container<Listing<Post>>) -> [Post] in
            self.afterLink = result.data.after ?? ""
            return result.data.children.map({ $0.data })
        })
        return future
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func image(from url: URL) -> AnyPublisher<Data?, URLSession.DataTaskPublisher.Failure> {
        return network.session.dataTaskPublisher(for: url)
            .map { (data, response) -> Data in
            return data
        }.eraseToAnyPublisher()
    }
}
