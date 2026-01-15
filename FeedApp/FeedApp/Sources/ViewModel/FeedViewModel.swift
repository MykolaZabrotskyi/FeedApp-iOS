//
//  FeedViewModel.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import UIKit

@MainActor
class FeedViewModel {
    
    struct PostCellViewModel {
        let title: String
        let body: String
        let likesText: String
        let dateText: String
        let showExpandButton: Bool
        let isExpanded: Bool
    }
    
    private(set) var posts: [Post] = []
    
    private var expandedPostIds: Set<Int> = []
    
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func loadPosts() {
        Task {
            do {
                let loadedPosts = try await NetworkManager.shared.fetchPosts()
                self.posts = loadedPosts
                
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
    
    func cellViewModel(for index: Int, containerWidth: CGFloat) -> PostCellViewModel {
        let post = posts[index]
        let isExpanded = expandedPostIds.contains(post.postId)
        
        let date = Date(timeIntervalSince1970: TimeInterval(post.timestamp))
        let dateString = dateFormatter.string(from: date)
        
        let isLongText = calculateIsTextLong(
            post.previewText,
            width: containerWidth - 32
        )
        
        return PostCellViewModel(
            title: post.title,
            body: post.previewText,
            likesText: "\(post.likesCount)",
            dateText: dateString,
            showExpandButton: isLongText,
            isExpanded: isExpanded
        )
    }
    
    private func calculateIsTextLong(_ text: String, width: CGFloat) -> Bool {
        let font = UIFont.systemFont(ofSize: 16)
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textRect = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(textRect.height / font.lineHeight) > 2
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
}
