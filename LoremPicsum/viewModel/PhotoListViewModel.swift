import Foundation
import SwiftUI
import Combine

@Observable
class PhotoListViewModel {
    enum State {
        case idle, loading, success([Photo]), failure(Error)
    }

    @MainActor @Published var state: State = .idle
    private let service: PhotoService

    init(service: PhotoService = .init()) {
        self.service = service
        Task { await fetchPhotos() }
    }
    
    @MainActor
    func fetchPhotos() async {
        state = .loading
        do {
            let photos = try await service.fetchPhotos()
            state = .success(photos)
        } catch {
            state = .failure(error)
        }
    }
}
