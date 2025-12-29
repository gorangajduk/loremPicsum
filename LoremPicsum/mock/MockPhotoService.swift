//
//  MockPhotoService.swift
//  LoremPicsum
//
//  Created by Goran Gajduk on 29.12.25.
//


import Foundation

// MARK: - Mock Photo Service (Returns fake data)

class MockPhotoService: PhotoServiceProtocol {
    func fetchPhotos(page: Int = 1, limit: Int = 30) async throws -> [Photo] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Return mock photos
        return (0..<limit).map { index in
            let photoId = (page - 1) * limit + index
            return Photo(
                id: "\(photoId)",
                author: "Mock Author \(photoId)",
                width: 4000,
                height: 3000,
                url: "https://unsplash.com/photos/mock-\(photoId)",
                download_url: "https://picsum.photos/id/\(photoId)/200/150"
            )
        }
    }
}

// MARK: - Mock Empty Photo Service (Returns empty array)

class MockEmptyPhotoService: PhotoServiceProtocol {
    func fetchPhotos(page: Int = 1, limit: Int = 30) async throws -> [Photo] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Return empty array
        return []
    }
}

// MARK: - Mock Error Photo Service (Throws error)

class MockErrorPhotoService: PhotoServiceProtocol {
    func fetchPhotos(page: Int = 1, limit: Int = 30) async throws -> [Photo] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Throw a network error
        throw PhotoServiceError.badResponse(statusCode: 500)
    }
}
