//
//  ContentView.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import SwiftUI
import Combine

struct ContentView : View {
    @ObservedObject var viewModel: PostsViewModel
    var body: some View {
        NavigationView {
            List (viewModel.posts, id: \.title) { post in
                PostView(post: post)
                    .onAppear {
                        self.viewModel.fetchMorePostsIfNeeded(item: post)
                    }
            }.navigationBarTitle("Reddit", displayMode: .inline)
        }
    }
}
