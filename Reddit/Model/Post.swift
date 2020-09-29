//
//  Post.swift
//  Reddit
//
//  Created by Sumitha Palanisamy on 9/28/20.
//

import SwiftUI

protocol ModelType: Codable, Hashable {
    
}

struct Container<T: ModelType>: ModelType {
    var data: T
}

struct Listing<T: ModelType>: ModelType {
    var children: [Container<T>]
    var after: String?
}

struct Post: ModelType {
    let id = UUID()
    var name: String
    var title: String
    var thumbnail: URL
    var thumbnailHeight: Double?
    var thumbnailWidth: Double?
    var numComments: Int?
    
    public enum CodingKeys: String, CodingKey {
        case name, title, thumbnail
        case thumbnailHeight = "thumbnail_height"
        case thumbnailWidth = "thumbnail_width"
        case numComments = "num_comments"
    }
}
