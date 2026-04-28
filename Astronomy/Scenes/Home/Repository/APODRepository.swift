//
//  APODRepository.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Foundation

enum DataSource<T> {
    case fresh(T)
    case cached(T, error: Error)
}

protocol APODRepositoryProtocol {
    func astronomy(for query: APODQuery) async throws -> DataSource<APODEntry>
}

final class APODRepository: APODRepositoryProtocol {
    
    enum HomeEndPoint: Endpoint {
        case fetch(APODQuery)
        
        var path: String { return "apod" }
        
        var method: HTTPMethod {
            switch self { case .fetch: .get }
        }
        
        var parameters: [String : String]? {
            switch self { case .fetch(let query): query.parameters }
        }
    }
    
    // MARK: Properties
    private let httpClient: HTTPClientProtocol
    private let cache: PersistenceProtocol
    private static let cacheKey = "apod_last"
    
    init(httpClient: HTTPClientProtocol, cache: any PersistenceProtocol) {
        self.httpClient = httpClient
        self.cache = cache
    }
    
    func astronomy(for query: APODQuery) async throws -> DataSource<APODEntry> {
        do {
            let endpoint: HomeEndPoint = .fetch(query)
            let apodEntry: APODEntry = try await httpClient.request(endpoint)
            try? cache.save(apodEntry, forKey: Self.cacheKey)
            return .fresh(apodEntry)
        } catch {
            guard let cachedAPODEntry = cache.load(type: APODEntry.self, forKey: Self.cacheKey) else {
                throw error
            }
            return .cached(cachedAPODEntry, error: error)
        }
    }
}
