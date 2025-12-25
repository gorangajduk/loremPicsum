// Create a new Swift file named PhotoService.swift
// This file will define a PhotoService responsible for fetching photos from the Lorem Picsum API using async/await
// Include error handling for network and decoding errors

import Foundation

enum PhotoServiceError: Error, LocalizedError {
    case invalidURL
    case network(Error)
    case badResponse
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .badResponse:
            return "The server returned an invalid response."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

struct PhotoService {
    let session: URLSession
    private let baseURL = "https://picsum.photos/v2/list"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPhotos() async throws -> [Photo] {
        guard let url = URL(string: baseURL) else {
            throw PhotoServiceError.invalidURL
        }
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw PhotoServiceError.badResponse
            }
            do {
                return try JSONDecoder().decode([Photo].self, from: data)
            } catch {
                throw PhotoServiceError.decoding(error)
            }
        } catch {
            throw PhotoServiceError.network(error)
        }
    }
}
