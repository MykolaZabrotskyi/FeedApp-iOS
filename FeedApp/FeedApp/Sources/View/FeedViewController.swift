//
//  FeedViewController.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import UIKit

class FeedViewController: UIViewController {

    private lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "FeedApp"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        print("Downloading...")
        
        Task {
            do {
                let posts = try await NetworkManager.shared.fetchPosts()
                print("Feed loaded! Posts received: \(posts.count)")
                
                if let firstPost = posts.first {
                    print("Trying to load details for post ID: \(firstPost.postId)")
                    
                    await testDetailLoading(id: firstPost.postId)
                }
                
            } catch {
                print("Error loading feed: \(error)")
            }
        }
    }
    
    private func testDetailLoading(id: Int) async {
        do {
            let detail = try await NetworkManager.shared.fetchPostDetails(id: id)
            
            print("Details uploaded successfully!")
            print("   Title: \(detail.title)")
            print("   Full text (first 50 characters): \(detail.text.prefix(50))...")
            print("   Picture: \(detail.postImage)")
            
        } catch {
            print("Error loading details: \(error)")
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(testLabel)
        
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
