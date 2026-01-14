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
            
            NetworkManager.shared.fetchPosts { [weak self] result in
                
                switch result {
                case .success(let posts):
                    print("Feed loaded! Posts received: \(posts.count)")
                    
                    if let firstPost = posts.first {
                        print("Trying to load details for post ID: \(firstPost.postId)")
                        
                        self?.testDetailLoading(id: firstPost.postId)
                    }
                    
                case .failure(let error):
                    print("Error loading feed: \(error)")
                }
            }
        }
        
        private func testDetailLoading(id: Int) {
            NetworkManager.shared.fetchPostDetails(id: id) { result in
                switch result {
                case .success(let detail):
                    print("Details uploaded successfully!")
                    print("   Title: \(detail.title)")
                    print("   Full text (first 50 characters): \(detail.text.prefix(50))...")
                    print("   Picture: \(detail.postImage)")
                case .failure(let error):
                    print("Error loading details: \(error)")
                }
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
