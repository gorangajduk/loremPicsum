//
//  ImageFailureView.swift
//  LoremPicsum
//
//  Created by Goran Gajduk on 28.12.25.
//

import SwiftUI

struct ImageFailureView: View {
    let iconSize: CGFloat
    let message: String
    
    init(iconSize: CGFloat = 30, message: String = "Failed to load") {
        self.iconSize = iconSize
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo.fill.on.rectangle.fill")
                .font(.system(size: iconSize))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}
