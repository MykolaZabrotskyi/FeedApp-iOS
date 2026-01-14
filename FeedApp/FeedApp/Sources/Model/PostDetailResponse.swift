//
//  PostDetailsResponse.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import Foundation

struct PostDetailResponse: Codable {
    let post: PostDetail
}

struct PostDetail: Codable {
    let postId: Int
    let timestamp: Int
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId
        case timestamp = "timeshamp"
        case title
        case text
        case postImage
        case likesCount = "likes_count"
    }
}
