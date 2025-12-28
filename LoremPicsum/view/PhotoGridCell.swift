//
//  PhotoGridCell.swift
//  LoremPicsum
//
//  Created by Goran Gajduk on 28.12.25.
//

import SwiftUI
import Foundation

struct PhotoGridCell: View {
    let photo: Photo

    var body: some View {
        AsyncImage(url: URL(string: photo.download_url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Color.red.overlay(Text("✗"))
            } else {
                ProgressView()
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .clipped()
    }
}
