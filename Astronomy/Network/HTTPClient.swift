//
//  HTTPClient.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Foundation

// MARK: - Protocol

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol HTTPClientProtocol {
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T
}

// MARK: - Client

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        guard let request = try RequestBuilder.build(with: endpoint) else {
            throw HTTPError.invalidRequest
        }
        NetworkLogger.logRequest(request)
        
        do {
            let (data, response) = try await session.data(for: request)
            NetworkLogger.logResponse(response, data: data)
            return try ResponseDecoder.decodeResponse(data: data, response: response)
        } catch let error as HTTPError {
            throw error
        } catch let urlError as URLError {
            throw urlError.asHTTPError
        } catch {
            throw HTTPError.unknown
        }
    }
}
