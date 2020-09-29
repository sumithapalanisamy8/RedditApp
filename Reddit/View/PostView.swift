//
//  PostView.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//
import SwiftUI

struct PostView: View {
    var post: Post
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Spacer()
            Text(post.title)
                .bold()
            ThumbnailView(post: self.post)
            CommentView(comments: post.numComments ?? 0)
        })
    }
}

struct ThumbnailView: View {
    @ObservedObject var urlImage: UrlImage
    private var post: Post

    init(post: Post) {
        self.post = post
        self.urlImage = UrlImage(url: post.thumbnail)
    }

    var body: some View {
        HStack {
            Image(uiImage: urlImage.image ?? UIImage(named: "Loader")!)
                .resizable()
                .frame(maxWidth: .infinity, minHeight: CGFloat(self.post.thumbnailHeight ?? 40), alignment: .center)
                .scaledToFit()
                .aspectRatio(CGSize(width:CGFloat(self.post.thumbnailWidth ?? 60.0), height: CGFloat(self.post.thumbnailHeight ?? 40.0)), contentMode: .fit)
        }.onAppear(perform: {
            self.urlImage.fetchImage()
        })
    }
}

struct CommentView: View {
    var numComments: Int
    init(comments: Int) {
        self.numComments = comments
    }

    var body: some View {
        HStack {
            Image(systemName: "text.bubble.fill")
            Text("\(self.numComments)")
        }
    }
}
