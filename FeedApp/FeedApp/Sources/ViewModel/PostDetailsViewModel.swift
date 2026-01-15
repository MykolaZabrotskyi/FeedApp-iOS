//
//  PostDetailsViewModel.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 15.01.2026.
//

import Foundation

@MainActor
class PostDetailsViewModel {
    
    private let postId: Int
    
    private(set) var post: PostDetail?
    
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(postId: Int) {
        self.postId = postId
    }
    
    func loadDetails() {
        Task {
            do {
                let detail = try await NetworkManager.shared.fetchPostDetails(id: postId)
                self.post = detail
                self.onDataLoaded?()
            } catch {
                self.onError?(error.localizedDescription)
            }
        }
    }
}
