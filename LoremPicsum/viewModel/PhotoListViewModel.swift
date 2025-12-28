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

    init(service: PhotoService? = nil) {
        self.service = service ?? PhotoService()
        Task {
            await fetchPhotos()
        }
    }

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
