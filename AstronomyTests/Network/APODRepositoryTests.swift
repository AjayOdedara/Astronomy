//
//  APODRepositoryTests.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import XCTest
@testable import Astronomy

@MainActor
final class APODRepositoryTests: XCTestCase {

    // MARK: - Fixture

    private let mockEntry = APODEntry(
        date: "2024-01-15",
        title: "Mock Galaxy",
        description: "A test description.",
        mediaType: .image,
        url: "https://example.com/image.jpg"
    )

    // MARK: - Tests

    func test_astronomy_networkSuccess_returnsFreshAndSavesCache() async throws {
        let cache = MockCache()
        let sut = APODRepository(
            httpClient: MockHTTPClient(result: .success(mockEntry)),
            cache: cache
        )

        let result = try await sut.astronomy(for: .today)

        guard case .fresh(let entry) = result else {
            return XCTFail("Expected .fresh, got \(result)")
        }
        XCTAssertEqual(entry.title, mockEntry.title)
        XCTAssertNotNil(cache.load(type: APODEntry.self, forKey: "apod_last"), "Entry should be saved to cache")
    }

    func test_astronomy_networkFails_cachedEntryExists_returnsCached() async throws {
        let cache = MockCache()
        try cache.save(mockEntry, forKey: "apod_last")

        let sut = APODRepository(
            httpClient: MockHTTPClient(result: .failure(HTTPError.notConnectedToInternet)),
            cache: cache
        )

        let result = try await sut.astronomy(for: .today)

        guard case .cached(let entry, _) = result else {
            return XCTFail("Expected .cached, got \(result)")
        }
        XCTAssertEqual(entry.title, mockEntry.title)
    }

    func test_astronomy_networkFails_noCacheExists_throwsError() async {
        let sut = APODRepository(
            httpClient: MockHTTPClient(result: .failure(HTTPError.notConnectedToInternet)),
            cache: MockCache()
        )

        do {
            _ = try await sut.astronomy(for: .today)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? HTTPError, .notConnectedToInternet)
        }
    }
}
