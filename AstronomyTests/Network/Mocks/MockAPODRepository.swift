//
//  MockAPODRepository.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

@testable import Astronomy

final class MockAPODRepository: APODRepositoryProtocol, @unchecked Sendable {
    var result: Result<DataSource<APODEntry>, Error>
    private(set) var callCount = 0
    private(set) var lastQuery: APODQuery?

    init(result: Result<DataSource<APODEntry>, Error>) {
        self.result = result
    }

    func astronomy(for query: APODQuery) async throws -> DataSource<APODEntry> {
        callCount += 1
        lastQuery = query
        switch result {
        case .success(let source): return source
        case .failure(let error):  throw error
        }
    }
}
