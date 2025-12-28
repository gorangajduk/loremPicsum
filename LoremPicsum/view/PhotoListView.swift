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
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(photos) { photo in
                                NavigationLink {
                                    PhotoDetailView(photo: photo)
                                } label: {
                                    PhotoGridCell(photo: photo)
                                }
                                .buttonStyle(.plain) 
                            }
                        }
                        .padding(16)
                    }
                    .refreshable {
                        await viewModel.fetchPhotos()
                    }
                }
            }
            .navigationTitle("Photos")
        }
    }
}
