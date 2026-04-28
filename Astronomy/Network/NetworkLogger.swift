//
//  NetworkLogger.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation

struct NetworkLogger {
    // MARK: - Debug-only verbose logging
    static func logRequest(_ request: URLRequest) {
        #if DEBUG
        var components = request.url
            .flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
        components?.query = nil          // strips everything after ?
        let url = components?.url?.absoluteString ?? "nil"
        print("➡️ [\(request.httpMethod ?? "GET")] \(url)")
        #endif
    }

    static func logResponse(_ response: URLResponse, data: Data) {
        #if DEBUG
        if let http = response as? HTTPURLResponse {
            var components = http.url
                .flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
            components?.query = nil
            let url = components?.url?.absoluteString ?? "nil"
            print("⬅️ [\(http.statusCode)] \(url)")
        }
        if let str = String(data: data, encoding: .utf8) {
            print("Body: \(str)")
        }
        #endif
    }
}
