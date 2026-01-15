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
            static let cornerRadius: CGFloat = 8
            static let font: UIFont = .systemFont(ofSize: 14, weight: .medium)
            static let height: CGFloat = 36
        }
        
        struct Fonts {
            static let title: UIFont = .systemFont(ofSize: 18, weight: .bold)
            static let body: UIFont = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Metrics.Fonts.title
        label.textColor = .systemIndigo
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
    
    func configure(with post: Post, isExpanded: Bool) {
        titleLabel.text = post.title
        bodyLabel.text = post.previewText
        
        var screenWidth: CGFloat = 0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            screenWidth = windowScene.screen.bounds.width
        } else {
            // Фоллбек (на випадок якщо щось піде не так, хоча це малоймовірно)
            screenWidth = 375 // Стандартна ширина
        }
        
        let contentWidth = screenWidth - (Metrics.padding * 2)
        // 2. Перевіряємо, чи текст довгий
        let isLongText = isTextLongerThanTwoLines(
            text: post.previewText,
            font: Metrics.Fonts.body,
            width: contentWidth
        )
        
        // 3. Логіка кнопки
        if !isLongText {
            // А. Текст короткий -> ховаємо кнопку
            expandButton.isHidden = true
            buttonHeightConstraint?.constant = 0 // Сплющуємо кнопку
            bodyLabel.numberOfLines = 0 // Показуємо все (там і так < 2 рядків)
        } else {
            // Б. Текст довгий -> показуємо кнопку і обробляємо Expand/Collapse
            expandButton.isHidden = false
            buttonHeightConstraint?.constant = Metrics.Button.height // Відновлюємо висоту
            
            if isExpanded {
                bodyLabel.numberOfLines = 0
                expandButton.setTitle("Collapse", for: .normal)
            } else {
                bodyLabel.numberOfLines = 2
                expandButton.setTitle("Expand", for: .normal)
            }
        }
        
        let imageAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(scale: Metrics.Likes.iconScale)
        if let image = UIImage(systemName: Metrics.Likes.iconName, withConfiguration: config)?
            .withTintColor(Metrics.Likes.color, renderingMode: .alwaysOriginal) {
            imageAttachment.image = image
            imageAttachment.bounds = CGRect(x: 0, y: -2.5, width: image.size.width, height: image.size.height)
        }
        
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        let textString = NSAttributedString(string: " \(post.likesCount)")
        fullString.append(textString)
        likesLabel.attributedText = fullString
        
        let date = Date(timeIntervalSince1970: TimeInterval(post.timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        dateLabel.text = formatter.string(from: date)
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
