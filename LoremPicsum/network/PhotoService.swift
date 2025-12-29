// PhotoService.swift
// This file defines a PhotoService responsible for fetching photos from the Lorem Picsum API using async/await
// Include error handling for network and decoding errors

import Foundation


/// Protocol defining the interface for fetching photos
protocol PhotoServiceProtocol {
    func fetchPhotos(page: Int, limit: Int) async throws -> [Photo]
}

enum PhotoServiceError: Error, LocalizedError {
    case invalidURL
    case network(Error)
    case badResponse(statusCode: Int)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .badResponse(let statusCode):
            return "The server returned an invalid response (status code: \(statusCode))."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

struct PhotoService: PhotoServiceProtocol {
    private let session: URLSession
    private let baseURL = "https://picsum.photos/v2/list"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPhotos(page: Int = 1, limit: Int = 30) async throws -> [Photo] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw PhotoServiceError.invalidURL
        }
        
        // Add query parameters for pagination
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        guard let url = urlComponents.url else {
            throw PhotoServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw PhotoServiceError.badResponse(statusCode: 0)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw PhotoServiceError.badResponse(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([Photo].self, from: data)
            } catch {
                throw PhotoServiceError.decoding(error)
            }
        } catch let error as PhotoServiceError {
            throw error
        } catch {
            throw PhotoServiceError.network(error)
        }
    }
}
