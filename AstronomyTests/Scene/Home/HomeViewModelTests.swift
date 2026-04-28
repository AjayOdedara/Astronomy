//
//  HomeViewModelTests.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import XCTest
@testable import Astronomy

@MainActor
final class HomeViewModelTests: XCTestCase {

    func test_onAppear_transitionsFromIdleToLoaded() async {
        let sut = HomeViewModel(
            homeService: MockAPODRepository(result: .success(.fresh(.fixture)))
        )

        await sut.onAppear()

        guard case .loaded(.fresh(let entry)) = sut.apodState else {
            return XCTFail("Expected .loaded(.fresh), got \(sut.apodState)")
        }
        XCTAssertEqual(entry.title, APODEntry.fixture.title)
    }

    func test_onAppear_repositoryFails_transitionsToError() async {
        let sut = HomeViewModel(
            homeService: MockAPODRepository(result: .failure(HTTPError.notConnectedToInternet))
        )

        await sut.onAppear()

        guard case .error(let error) = sut.apodState else {
            return XCTFail("Expected .error, got \(sut.apodState)")
        }
        XCTAssertEqual(error as? HTTPError, .notConnectedToInternet)
    }

    func test_onRetry_usesCurrentQuery() async {
        let mockRepo = MockAPODRepository(result: .failure(HTTPError.notConnectedToInternet))
        let sut = HomeViewModel(homeService: mockRepo)

        await sut.onAppear()
        XCTAssertEqual(mockRepo.lastQuery, .today)

        mockRepo.result = .success(.fresh(.fixture))
        await sut.onRetry()

        XCTAssertEqual(mockRepo.callCount, 2)
        XCTAssertEqual(mockRepo.lastQuery, .today)
        guard case .loaded = sut.apodState else {
            return XCTFail("Expected .loaded after retry")
        }
    }

    func test_onAppear_doesNotRefetchAfterInitialLoad() async {
        let mockRepo = MockAPODRepository(result: .success(.fresh(.fixture)))
        let sut = HomeViewModel(homeService: mockRepo)

        await sut.onAppear()
        await sut.onAppear()

        XCTAssertEqual(mockRepo.callCount, 1)
    }
}
