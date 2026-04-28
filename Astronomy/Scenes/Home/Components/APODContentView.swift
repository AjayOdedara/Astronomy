//
//  APODContentView.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import SwiftUI
import AVKit

struct APODContentView: View {
    let entry: APODEntry
    let imageService: any ImageServiceProtocol
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                mediaView
                    .frame(maxWidth: .infinity)
                    .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    Text(entry.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(entry.date)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Divider()

                    Text(entry.description)
                        .font(.body)
                        .lineSpacing(4)
                }
                .padding()
            }
        }
        
    }

    @ViewBuilder
    private var mediaView: some View {
        switch entry.mediaType {
        case .image:
            CachedAsyncImage(urlString: entry.url, imageService: imageService) { phase in
                switch phase {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGray6))
                case .success(let image):
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 380)
                        .accessibilityLabel(entry.title)
                case .failure:
                    Image(systemName: "photo.slash")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGray6))
                        .accessibilityHidden(true)
                }
            }
        case .video:
            if let url = URL(string: entry.url) {
                APODVideoView(url: url)
                    .accessibilityLabel("Video: \(entry.title)")
            } else {
                Text("Video unavailable")
                    .foregroundStyle(.secondary)
                    .accessibilitySpeak(HomeAccessibility.Speak.cachedBanner)
            }
        }
    }
}
