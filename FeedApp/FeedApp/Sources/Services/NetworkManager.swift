//
//  NetworkManager.swift
//  FeedApp
//
//  Created by Mykola Zabrotskyi on 14.01.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let postsURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
    
    func fetchPosts(completion: @escaping (Result<[Post], NetworkError>) -> Void) {
        guard let url = URL(string: postsURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.noData))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PostsResponse.self, from: data)
                completion(.success(response.posts))
            } catch {
                print("Decoding error (Posts): \(error)")
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    func fetchPostDetails(id: Int, completion: @escaping (Result<PostDetail, NetworkError>) -> Void) {
        let detailURLString = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(id).json"
        
        guard let url = URL(string: detailURLString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.noData))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PostDetailResponse.self, from: data)
                completion(.success(response.post))
            } catch {
                print("Decoding error (Detail): \(error)")
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
