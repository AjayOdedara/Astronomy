//
//  CachedAsyncImage.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation
import SwiftUI

enum ImagePhase {
    case loading
    case success(UIImage)
    case failure(Error)
}

struct CachedAsyncImage<Content: View>: View {
    let urlString: String?
    var imageService: any ImageServiceProtocol
    @ViewBuilder let content: (ImagePhase) -> Content
    
    @State private var phase: ImagePhase = .loading

    var body: some View {
        content(phase)
            .task(id: urlString) { await load() }
    }

    private func load() async {
        guard let urlString else { return }
        phase = .loading
        do {
            let image = try await imageService.image(for: urlString)
            phase = .success(image)
        } catch {
            phase = .failure(error)
        }
    }
}
