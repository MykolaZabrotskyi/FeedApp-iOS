//
//  PostDetailsViewModel.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 15.01.2026.
//

import Foundation

@MainActor
class PostDetailsViewModel {
    
    struct PostDetailsDisplayModel {
        let title: String
        let description: String
        let likesCount: String
        let date: String
        let imageUrl: String
    }
    
    private let postId: Int
    
    private(set) var displayModel: PostDetailsDisplayModel?
    
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    init(postId: Int) {
        self.postId = postId
    }
    
    func loadDetails() {
        Task {
            do {
                let post = try await NetworkManager.shared.fetchPostDetails(id: postId)
                
                self.displayModel = PostDetailsDisplayModel(
                    title: post.title,
                    description: post.text,
                    likesCount: "\(post.likesCount)",
                    date: dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(post.timestamp))),
                    imageUrl: post.postImage
                )
                
                onDataLoaded?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
