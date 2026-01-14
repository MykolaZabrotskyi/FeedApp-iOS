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
