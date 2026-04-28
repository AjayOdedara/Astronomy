//
//  ErrorView.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ErrorView(message: "Error message") { }
}

