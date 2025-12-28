// Create a SwiftUI view for showing details of a selected Photo
import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AsyncImage(url: URL(string: photo.download_url)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(16)
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
            .navigationTitle("Photo Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
