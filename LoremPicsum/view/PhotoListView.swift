import SwiftUI
import Combine
import Foundation

struct PhotoListView: View {
    @State private var viewModel = PhotoListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading Photos...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failure(let error):
                    VStack(spacing: 16) {
                        Text("Failed to load photos.")
                        Text(error.localizedDescription).font(.caption).foregroundStyle(.secondary)
                        Button("Retry") {
                            Task { await viewModel.fetchPhotos() }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let photos):
                    List(photos) { photo in
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: photo.download_url)) { phase in
                                if let image = phase.image {
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } else if phase.error != nil {
                                    Color.red.overlay(Text("✗").font(.caption))
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                            Text(photo.author)
                                .font(.headline)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Photos")
        }
    }
}
