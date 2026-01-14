import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let postsURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
    
    private func fetch<T: Decodable>(from urlString: String) async throws -> T {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.unknown
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error for \(T.self): \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func fetchPosts() async throws -> [Post] {
        let response: PostsResponse = try await fetch(from: postsURL)
        return response.posts
    }
    
    func fetchPostDetails(id: Int) async throws -> PostDetail {
        let urlString = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(id).json"
        let response: PostDetailResponse = try await fetch(from: urlString)
        return response.post
    }
}
