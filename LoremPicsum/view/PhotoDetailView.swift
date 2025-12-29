import SwiftUI
import Kingfisher

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Photo Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .accessibilityIdentifier("photoDetailTitle")
                
                KFImage(URL(string: photo.download_url))
                    .placeholder {
                        ProgressView()
                            .frame(height: 240)
                            .accessibilityIdentifier("photoDetailImageLoading")
                    }
                    .onFailureView {
                        ImageFailureView(iconSize: 50, message: "Failed to load image")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .background(Color(white: 0.95))
                    .frame(maxWidth: .infinity, maxHeight: 320)
                    .accessibilityIdentifier("photoDetailImage")
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Author: \(photo.author)")
//                        .bold()
                        .accessibilityIdentifier("photoDetailAuthor")
                    Text("ID: \(photo.id)")
                        .accessibilityIdentifier("photoDetailID")
                    Text("Size: \(photo.width) × \(photo.height)")
                        .accessibilityIdentifier("photoDetailSize")
                    if let url = URL(string: photo.url) {
                        Link("URL: \(photo.url)", destination: url)
                            .accessibilityIdentifier("photoDetailURL")
                    } else {
                        Text("URL: \(photo.url)")
                            .accessibilityIdentifier("photoDetailURL")
                    }
                }
                .font(.body)
                .padding(.horizontal)
            }
        }
        .accessibilityIdentifier("photoDetailScrollView")
    }
}
