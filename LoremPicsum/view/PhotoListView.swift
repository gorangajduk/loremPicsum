import SwiftUI
import Foundation

struct PhotoListView: View {
    @State private var viewModel = PhotoListViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
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
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button("Retry") {
                            Task { await viewModel.fetchPhotos() }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .success(let photos):
                    if photos.isEmpty {
                        // Empty state when no photos are available
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No Photos Available")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Pull down to refresh")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                                    NavigationLink {
                                        PhotoDetailView(photo: photo)
                                    } label: {
                                        PhotoGridCell(photo: photo)
                                            .onAppear {
                                                // Trigger pagination when user scrolls near the end
                                                // Load more when reaching the last 5 items
                                                if index == photos.count - 5 {
                                                    Task {
                                                        await viewModel.loadMorePhotos()
                                                    }
                                                }
                                            }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(16)
                        }
                        .refreshable {
                            // Pull-to-refresh resets to first page
                            await viewModel.fetchPhotos()
                        }
                    }
                }
            }
            .navigationTitle("Photos")
        }
    }
}
