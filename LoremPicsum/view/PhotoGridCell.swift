//
//  PhotoGridCell.swift
//  LoremPicsum
//
//  Created by Goran Gajduk on 28.12.25.
//
import SwiftUI
import Kingfisher

struct PhotoGridCell: View {
    let photo: Photo
    
    var body: some View {
        KFImage(URL(string: photo.download_url))
            .placeholder {
                ProgressView()
            }
            .onFailureView {
                ImageFailureView()
            }
            .resizable()
            .scaledToFit()
            .frame(height: 150)
    }
}
