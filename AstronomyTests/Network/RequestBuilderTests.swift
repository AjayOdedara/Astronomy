//
//  RequestBuilderTests.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import XCTest
@testable import Astronomy

final class RequestBuilderTests: XCTestCase {

    // MARK: - Mock

    private struct MockEndpoint: Endpoint {
        var host: String = "https://api.nasa.gov/planetary/"
        var path: String = "apod"
        var method: HTTPMethod = .get
        var headers: [String: String]? = ["Content-Type": "application/json"]
        var body: [String: Any]? = nil
        var parameters: [String: String]? = nil
        var timeOut: Double = 30.0
    }

    // MARK: - Helper

    private func queryValue(for key: String, in request: URLRequest) -> String? {
        guard let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return nil }
        return components.queryItems?.first(where: { $0.name == key })?.value
    }

    // MARK: - Tests

    func test_build_setsGETMethodAndCorrectURL() throws {
        let request = try XCTUnwrap(RequestBuilder.build(with: MockEndpoint()))

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.host, "api.nasa.gov")
        XCTAssertEqual(request.url?.path, "/planetary/apod")
    }

    func test_build_includesAPIKey() throws {
        var endpoint = MockEndpoint()
        endpoint.parameters = APODQuery.today.parameters

        let request = try XCTUnwrap(RequestBuilder.build(with: endpoint))

        XCTAssertEqual(queryValue(for: "api_key", in: request), Config.nasaAPIKey)
    }

    func test_build_includesDateInYYYYMMDDFormat() throws {
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15
        components.timeZone = TimeZone(identifier: "UTC")
        let date = Calendar(identifier: .gregorian).date(from: components)!

        var endpoint = MockEndpoint()
        endpoint.parameters = APODQuery.single(date: date).parameters

        let request = try XCTUnwrap(RequestBuilder.build(with: endpoint))

        XCTAssertEqual(queryValue(for: "date", in: request), "2024-01-15")
    }

    func test_build_appliesHeadersAndTimeout() throws {
        var endpoint = MockEndpoint()
        endpoint.headers  = ["Content-Type": "application/json"]
        endpoint.timeOut  = 30.0

        let request = try XCTUnwrap(RequestBuilder.build(with: endpoint))

        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(request.timeoutInterval, 30.0)
    }
}
