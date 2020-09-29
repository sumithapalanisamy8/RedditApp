//
//  RedditApp.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import SwiftUI

@main
struct RedditApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: PostsViewModel())
        }
    }
}
