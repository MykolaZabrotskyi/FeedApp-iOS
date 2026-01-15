//
//  FeedViewModel.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import Foundation

@MainActor
class FeedViewModel {

    private(set) var posts: [Post] = []
    
    private var expandedPostIds: Set<Int> = []
    
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func loadPosts() {
        Task {
            do {
                let loadedPosts = try await NetworkManager.shared.fetchPosts()
                self.posts = loadedPosts
                
                // self.expandedPostIds.removeAll()
                self.onDataLoaded?()
            } catch {
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfPosts() -> Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    func isPostExpanded(at index: Int) -> Bool {
        let post = posts[index]
        return expandedPostIds.contains(post.postId)
    }
    
    func togglePostExpansion(at index: Int) {
        let post = posts[index]
        
        if expandedPostIds.contains(post.postId) {
            expandedPostIds.remove(post.postId)
        } else {
            expandedPostIds.insert(post.postId)
        }
    }
}
