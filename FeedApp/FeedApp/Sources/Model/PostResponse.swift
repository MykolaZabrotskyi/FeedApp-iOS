//
//  Post.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import Foundation

struct PostsResponse: Codable {
    let posts: [Post]
}

struct Post: Codable {
    let postId: Int
    let timestamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId
        case timestamp = "timeshamp"
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}
