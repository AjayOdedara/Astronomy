//
//  APODVideoView.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import WebKit
import SwiftUI

struct APODVideoView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = [.all]
        return WKWebView(frame: .zero, configuration: config)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard webView.url != url else { return }
        webView.load(URLRequest(url: url))
    }
}
