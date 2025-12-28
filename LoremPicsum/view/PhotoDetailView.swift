import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Title below back button
                Text("Photo Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                AsyncImage(url: URL(string: photo.download_url)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } else if phase.error != nil {
                        Color.red.overlay(Text("✗").font(.largeTitle))
                            .frame(height: 240)
                    } else {
                        ProgressView()
                            .frame(height: 240)
                    }
                }
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
