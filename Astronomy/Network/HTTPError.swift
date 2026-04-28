//
//  HTTPError.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Foundation

enum HTTPError: Error, LocalizedError {
    case invalidResponse
    case invalidRequest
    case noConnection
    case decodingFailed
    case notConnectedToInternet
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Service unavailable. Please try again later."
        case .invalidRequest: return "Invalid request"
        case .unknown: return "Something went wrong. Please try again."
        case .noConnection: return "Connection lost. Try again."
        case .decodingFailed: return "Failed to decode data"
        case .notConnectedToInternet: return "You're offline. Check your connection."
        }
    }
}

extension URLError {
    var asHTTPError: HTTPError {
        switch code {
        case .notConnectedToInternet: return .notConnectedToInternet
        case .networkConnectionLost: return .noConnection
        default: return .unknown
        }
    }
}
