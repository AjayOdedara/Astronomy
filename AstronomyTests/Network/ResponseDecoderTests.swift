//
//  ResponseDecoderTests.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import XCTest
@testable import Astronomy

final class ResponseDecoderTests: XCTestCase {

    // MARK: - Helpers

    private struct MockModel: Decodable, Equatable {
        let id: Int
        let name: String
    }

    private func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://api.nasa.gov")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    private func makeJSON(_ dict: [String: Any]) -> Data {
        try! JSONSerialization.data(withJSONObject: dict)
    }

    // MARK: - Valid 2xx

    func test_200_validJSON_decodesSuccessfully() throws {
        let data = makeJSON(["id": 1, "name": "Galaxy"])
        let response = makeHTTPResponse(statusCode: 200)

        let result: MockModel = try ResponseDecoder.decodeResponse(data: data, response: response)

        XCTAssertEqual(result, MockModel(id: 1, name: "Galaxy"))
    }

    func test_299_validJSON_decodesSuccessfully() throws {
        let data = makeJSON(["id": 2, "name": "Nebula"])
        let response = makeHTTPResponse(statusCode: 299)

        let result: MockModel = try ResponseDecoder.decodeResponse(data: data, response: response)

        XCTAssertEqual(result, MockModel(id: 2, name: "Nebula"))
    }

    // MARK: - Non-2xx

    func test_400_throwsInvalidResponseWithStatusCode() {
        let data = makeJSON(["error": "bad request"])
        let response = makeHTTPResponse(statusCode: 400)

        XCTAssertThrowsError(
            try ResponseDecoder.decodeResponse(data: data, response: response) as MockModel
        ) { error in
            XCTAssertEqual(error as? HTTPError, .invalidResponse)
        }
    }

    // MARK: - Non-HTTP Response

    func test_nonHTTPResponse_throwsInvalidResponse() {
        let data = Data()
        let response = URLResponse()

        XCTAssertThrowsError(
            try ResponseDecoder.decodeResponse(data: data, response: response) as MockModel
        ) { error in
            XCTAssertEqual(error as? HTTPError, .invalidResponse)
        }
    }

    // MARK: - Invalid JSON

    func test_200_invalidJSON_throwsDecodingFailed() {
        let data = Data("not json at all".utf8)
        let response = makeHTTPResponse(statusCode: 200)

        XCTAssertThrowsError(
            try ResponseDecoder.decodeResponse(data: data, response: response) as MockModel
        ) { error in
            XCTAssertEqual(error as? HTTPError, .decodingFailed)
        }
    }

    func test_200_wrongJSONShape_throwsDecodingFailed() {
        let data = makeJSON(["unexpected": "keys"])
        let response = makeHTTPResponse(statusCode: 200)

        XCTAssertThrowsError(
            try ResponseDecoder.decodeResponse(data: data, response: response) as MockModel
        ) { error in
            XCTAssertEqual(error as? HTTPError, .decodingFailed)
        }
    }

    func test_200_emptyData_throwsDecodingFailed() {
        let data = Data()
        let response = makeHTTPResponse(statusCode: 200)

        XCTAssertThrowsError(
            try ResponseDecoder.decodeResponse(data: data, response: response) as MockModel
        ) { error in
            XCTAssertEqual(error as? HTTPError, .decodingFailed)
        }
    }
}
