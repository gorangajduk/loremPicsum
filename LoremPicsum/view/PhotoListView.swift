import SwiftUI
import Foundation

struct PhotoListView: View {
    @State private var viewModel: PhotoListViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    init(viewModel: PhotoListViewModel? = nil) {
        _viewModel = State(initialValue: viewModel ?? PhotoListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading Photos...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityIdentifier("loadingIndicator")
                    
                case .failure(let error):
                    VStack(spacing: 16) {
                        Text("Failed to load photos.")
                            .accessibilityIdentifier("errorTitle")
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("errorMessage")
                        Button("Retry") {
                            Task { await viewModel.fetchPhotos() }
                        }
                        .accessibilityIdentifier("retryButton")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .success(let photos):
                    if photos.isEmpty {
                        // Empty state when no photos are available
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .accessibilityIdentifier("photo.on.rectangle.angled")
                            Text("No Photos Available")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .accessibilityIdentifier("No Photos Available")
                            Text("Pull down to refresh")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .accessibilityIdentifier("Pull down to refresh")
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
                                            .accessibilityIdentifier("photoCell_\(photo.id)")
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
                        .accessibilityIdentifier("photoGrid")
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
