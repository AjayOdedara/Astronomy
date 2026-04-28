//
//  CachedBanner.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import SwiftUI

struct CachedBanner: View {
    let onRetry: () -> Void
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var isAccessibilitySize: Bool {
        dynamicTypeSize >= .accessibility1
    }

    var body: some View {
        Group {
            if isAccessibilitySize {
                VStack(alignment: .leading, spacing: 8) { bannerContent }
            } else {
                HStack(spacing: 8) { bannerContent }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) { Divider() }
    }

    @ViewBuilder
    private var bannerContent: some View {
        Image(systemName: "clock.arrow.circlepath")
            .foregroundStyle(.orange)
            .accessibilityHidden(true)
        Text("Showing cached content")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .accessibilitySpeak(HomeAccessibility.Speak.cachedBanner)
        Spacer()
        Button(action: onRetry) {
            Label("Retry", systemImage: "arrow.clockwise")
                .font(.footnote)
            
        }
        .buttonStyle(.bordered)
        .tint(.orange)
    }
}

#Preview {
    CachedBanner { }
}
