//
//  PostsViewModel.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import Foundation
import Combine

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    var subscriptions = Set<AnyCancellable>()
    let apiService: APIService
    
    init(api: APIService = APIService()) {
        self.apiService = api
        self.fetchPosts()
    }
    
    func fetchPosts(pagination: Bool = false) {
        self.apiService.getPostsList(pagination: pagination).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print("Error in fetching posts: \(error)")
            }
        }, receiveValue: { (posts) in
            self.posts.append(contentsOf: posts)
        })
        .store(in: &subscriptions)
    }
    
    func fetchMorePostsIfNeeded(item: Post?) {
        guard let item = item else {
            loadMorePosts()
            return
        }
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -5)
        if posts.firstIndex(where: {$0.id == item.id }) == thresholdIndex {
            loadMorePosts()
        }
    }
    
    private func loadMorePosts() {
        self.fetchPosts(pagination: true)
        
    }
}
