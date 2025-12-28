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
                
                KFImage(URL(string: photo.download_url))
                    .placeholder {
                        ProgressView()
                            .frame(height: 240)
                    }
                    .onFailureView {
                        ImageFailureView(iconSize: 50, message: "Failed to load image")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .background(Color(white: 0.95))
                    .frame(maxWidth: .infinity, maxHeight: 320)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Author: \(photo.author)").bold()
                    Text("ID: \(photo.id)")
                    Text("Size: \(photo.width) × \(photo.height)")
                    if let url = URL(string: photo.url) {
                        Link("URL: \(photo.url)", destination: url)
                    } else {
                        Text("URL: \(photo.url)")
                    }
                }
                .font(.body)
                .padding(.horizontal)
            }
        }
    }
}
