//
//  FeedViewController.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let viewModel = FeedViewModel()
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        
        config.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.register(PostCell.self, forCellWithReuseIdentifier: PostCell.id)
        
        return cv
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        viewModel.loadPosts()
    }
    
    private func setupUI() {
        title = "FeedApp"
        view.backgroundColor = .systemBackground
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemIndigo
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDataLoaded = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.id, for: indexPath) as? PostCell else {
            return UICollectionViewCell()
        }
        
        let cellVM = viewModel.cellViewModel(for: indexPath.row, containerWidth: collectionView.bounds.width)
        
        cell.configure(with: cellVM)
        
        cell.onExpandTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.togglePostExpansion(at: indexPath.row)
            
            self.collectionView.performBatchUpdates({
                let updatedVM = self.viewModel.cellViewModel(for: indexPath.row, containerWidth: collectionView.bounds.width)
                cell.configure(with: updatedVM)
                self.collectionView.collectionViewLayout.invalidateLayout()
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let post = viewModel.post(at: indexPath.row)
        
        let detailVC = PostDetailsViewController(postId: post.postId)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
