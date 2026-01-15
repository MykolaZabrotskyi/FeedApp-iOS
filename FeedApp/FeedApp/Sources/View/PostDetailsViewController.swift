//
//  PostDetailsViewController.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 15.01.2026.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    private let viewModel: PostDetailsViewModel
    
    private enum Metrics {
        
        static let padding: CGFloat = 16
        
        static let spacing: CGFloat = 8
        
        struct Likes {
            static let color: UIColor = .systemIndigo
            static let font: UIFont = .systemFont(ofSize: 14, weight: .medium)
            static let iconName = "heart.fill"
            static let iconScale: UIImage.SymbolScale = .small
        }
        
        struct Button {
            static let color: UIColor = .systemIndigo
            static let cornerRadius: CGFloat = 8
            static let font: UIFont = .systemFont(ofSize: 14, weight: .medium)
        }
        
        struct Fonts {
            static let title: UIFont = .systemFont(ofSize: 18, weight: .bold)
            static let body: UIFont = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.systemIndigo.cgColor

        iv.layer.cornerRadius = 12
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemIndigo
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemIndigo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(postId: Int) {
        self.viewModel = PostDetailsViewModel(postId: postId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadDetails()
    }
    
    private func setupBindings() {
        viewModel.onDataLoaded = { [weak self] in
            self?.updateUI()
        }
        
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func updateUI() {
        guard let post = viewModel.post else { return }
        
        titleLabel.text = post.title
        descriptionLabel.text = post.text
        
        let imageAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(scale: Metrics.Likes.iconScale)
        if let image = UIImage(systemName: Metrics.Likes.iconName, withConfiguration: config)?
            .withTintColor(Metrics.Likes.color, renderingMode: .alwaysOriginal) {
            imageAttachment.image = image
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: image.size.width, height: image.size.height)
        }
        
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        
        let textString = NSAttributedString(string: " \(post.likesCount)")
        fullString.append(textString)
        likesLabel.attributedText = fullString
        
        let date = Date(timeIntervalSince1970: TimeInterval(post.timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateLabel.text = formatter.string(from: date)
        
        postImageView.loadImage(from: post.postImage)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(postImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(dateLabel)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding), // Відступ зверху
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding), // Відступ зліва
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding), // Відступ справа
            postImageView.heightAnchor.constraint(equalToConstant: 250), // Фіксована висота
            
            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            dateLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
}
