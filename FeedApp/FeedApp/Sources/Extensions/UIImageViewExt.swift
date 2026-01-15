//
//  UIImageViewExt.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 15.01.2026.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        self.backgroundColor = .systemGray6
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        self.image = image
                        self.backgroundColor = .clear
                    }
                }
            } catch {
                await MainActor.run {
                    self.image = UIImage(systemName: "photo.badge.exclamationmark")
                    self.tintColor = .systemGray5
                    self.contentMode = .center
                    self.backgroundColor = .secondarySystemBackground
                }
            }
        }
    }
}
