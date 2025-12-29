import Foundation
import SwiftUI

@MainActor
@Observable
class PhotoListViewModel {
    enum State {
        case idle
        case loading
        case success([Photo])
        case failure(Error)
    }
    
    var state: State = .idle
    private let service: PhotoService
    
    // Pagination state
    private var currentPage = 1
    private let photosPerPage = 30
    private var isLoadingMore = false
    private var hasMorePages = true
    
    init(service: PhotoService? = nil) {
        self.service = service ?? PhotoService()
        Task {
            await fetchPhotos()
        }
    }
    
    /// Fetches the first page of photos (used for initial load and refresh)
    func fetchPhotos() async {
        state = .loading
        currentPage = 1
        hasMorePages = true
        
        do {
            let photos = try await service.fetchPhotos(page: currentPage, limit: photosPerPage)
            state = .success(photos)
        } catch {
            state = .failure(error)
        }
    }
    
    /// Loads the next page of photos and appends to existing photos
    func loadMorePhotos() async {
        // Prevent multiple simultaneous requests or loading when no more pages
        guard !isLoadingMore, hasMorePages else { return }
        
        // Only load more if we're in success state with existing photos
        guard case .success(let currentPhotos) = state else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        do {
            let newPhotos = try await service.fetchPhotos(page: currentPage, limit: photosPerPage)
            
            // If we get fewer photos than requested, we've reached the end
            if newPhotos.count < photosPerPage {
                hasMorePages = false
            }
            
            // Append new photos to existing ones
            state = .success(currentPhotos + newPhotos)
        } catch {
            // On error, revert page increment and show error
            currentPage -= 1
            state = .failure(error)
        }
        
        isLoadingMore = false
    }
}
