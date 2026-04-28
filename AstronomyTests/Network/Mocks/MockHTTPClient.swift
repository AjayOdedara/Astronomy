//
//  MockHTTPClient.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

@testable import Astronomy

final class MockHTTPClient: HTTPClientProtocol {
    var result: Result<APODEntry, Error>
    
    init(result: Result<APODEntry, Error>) {
        self.result = result
    }
    
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        switch result {
        case .success(let entry): return entry as! T
        case .failure(let error): throw error
        }
    }
}
