//
//  PostCell.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    static let id = "PostCell"
    
    var onExpandTapped: (() -> Void)?
    
    private var buttonHeightConstraint: NSLayoutConstraint?
    
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
            static let cornerRadius: CGFloat = 12
            static let font: UIFont = .systemFont(ofSize: 14, weight: .medium)
            static let height: CGFloat = 36
        }
        
        struct Title {
            static let font: UIFont = .systemFont(ofSize: 18, weight: .bold)
            static let color: UIColor = .systemIndigo
        }
        
        struct Fonts {
            static let body: UIFont = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Metrics.Title.font
        label.textColor = Metrics.Title.color
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = Metrics.Fonts.body
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Expand", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Metrics.Button.color
        button.layer.cornerRadius = Metrics.Button.cornerRadius
        button.titleLabel?.font = Metrics.Button.font
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(expandButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = Metrics.Likes.font
        label.textColor = Metrics.Likes.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Metrics.Likes.font
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func expandButtonAction() {
        onExpandTapped?()
    }
    
    private func isTextLongerThanTwoLines(text: String, font: UIFont, width: CGFloat) -> Bool {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let textRect = text.boundingRect(
            with: maxSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        let lineHeight = font.lineHeight
        
        let numberOfLines = ceil(textRect.height / lineHeight)
        
        return numberOfLines > 2
    }
    
    func configure(with viewModel: FeedViewModel.PostCellViewModel) {
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.body
        dateLabel.text = viewModel.dateText
        
        if !viewModel.showExpandButton {
            expandButton.isHidden = true
            buttonHeightConstraint?.constant = 0
            bodyLabel.numberOfLines = 0
        } else {
            expandButton.isHidden = false
            buttonHeightConstraint?.constant = Metrics.Button.height
            bodyLabel.numberOfLines = viewModel.isExpanded ? 0 : 2
            expandButton.setTitle(viewModel.isExpanded ? "Collapse" : "Expand", for: .normal)
        }
        
        setupLikesLabel(with: viewModel.likesText)
    }
    
    private func setupLikesLabel(with likes: String) {
        let imageAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(scale: Metrics.Likes.iconScale)
        if let image = UIImage(systemName: Metrics.Likes.iconName, withConfiguration: config)?
            .withTintColor(Metrics.Likes.color, renderingMode: .alwaysOriginal) {
            imageAttachment.image = image
            imageAttachment.bounds = CGRect(x: 0, y: -2.5, width: image.size.width, height: image.size.height)
        }
        
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSAttributedString(string: " \(likes)"))
        likesLabel.attributedText = fullString
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(expandButton)
        contentView.addSubview(likesLabel)
        contentView.addSubview(dateLabel)
        
        buttonHeightConstraint = expandButton.heightAnchor.constraint(equalToConstant: Metrics.Button.height)
        buttonHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.spacing),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding),
            
            expandButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: Metrics.spacing),
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding),
            
            likesLabel.topAnchor.constraint(equalTo: expandButton.bottomAnchor, constant: Metrics.spacing),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.padding),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.padding),
            
            dateLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.padding)
        ])
    }
}
