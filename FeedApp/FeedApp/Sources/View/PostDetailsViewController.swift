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
        
        struct Likes {
            static let color: UIColor = .systemIndigo
            static let font: UIFont = .systemFont(ofSize: 14, weight: .medium)
            static let iconName = "heart.fill"
            static let iconScale: UIImage.SymbolScale = .small
        }
        
        struct Image {
            static let borderWidth: CGFloat = 4
            static let cornerRadius: CGFloat = 12
            static let borderColor: CGColor = UIColor.systemIndigo.cgColor
        }
        
        struct Title {
            static let font: UIFont = .systemFont(ofSize: 22, weight: .bold)
            static let color: UIColor = .systemIndigo
        }
        
        struct Description {
            static let font: UIFont = .systemFont(ofSize: 18)
            static let color: UIColor = .systemIndigo
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
        
        iv.layer.borderWidth = Metrics.Image.borderWidth
        iv.layer.borderColor = Metrics.Image.borderColor

        iv.layer.cornerRadius = Metrics.Image.cornerRadius
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Metrics.Title.color
        label.font = Metrics.Title.font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Metrics.Description.font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = Metrics.Likes.color
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
        guard let model = viewModel.displayModel else { return }
        
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        dateLabel.text = model.date
        postImageView.loadImage(from: model.imageUrl)
        
        setupLikesLabel(with: model.likesCount)
    }

    private func setupLikesLabel(with count: String) {
        let imageAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(scale: Metrics.Likes.iconScale)
        
        if let image = UIImage(systemName: Metrics.Likes.iconName, withConfiguration: config)?
            .withTintColor(Metrics.Likes.color, renderingMode: .alwaysOriginal) {
            imageAttachment.image = image
            imageAttachment.bounds = CGRect(x: 0, y: -1.8, width: image.size.width, height: image.size.height)
        }
        
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSAttributedString(string: " \(count)"))
        likesLabel.attributedText = fullString
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
            
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.padding),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding),
            postImageView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: Metrics.padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding),
            
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.padding),
            
            dateLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding)
        ])
    }
}
