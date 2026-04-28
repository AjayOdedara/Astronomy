//
//  ResponseDecoder.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation

struct ResponseDecoder {
    static func decodeResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return try decodeData(data)
        default:
            throw HTTPError.invalidResponse
        }
    }

    static func decodeData<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw HTTPError.decodingFailed
        }
    }
}

