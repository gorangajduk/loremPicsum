//
//  LoremPicsumApp.swift
//  LoremPicsum
//
//  Created by Goran Gajduk on 25.12.25.
//

import SwiftUI

@main
struct LoremPicsumApp: App {
    var body: some Scene {
        WindowGroup {
            // Check if running UI tests
            if CommandLine.arguments.contains("UI-Testing") {
                // Configure for testing scenarios
                if CommandLine.arguments.contains("Empty-State") {
                    PhotoListView(viewModel: PhotoListViewModel(service: MockEmptyPhotoService()))
                } else if CommandLine.arguments.contains("Error-State") {
                    PhotoListView(viewModel: PhotoListViewModel(service: MockErrorPhotoService()))
                } else {
                    // Use mock service with fake data for normal UI testing
                    PhotoListView(viewModel: PhotoListViewModel(service: MockPhotoService()))
                }
            } else {
                PhotoListView()
            }
        }
    }
}
