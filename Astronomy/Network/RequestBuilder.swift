//
//  RequestBuilder.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Foundation

struct RequestBuilder {
    static func build(with requestConfig: Endpoint) throws -> URLRequest? {
        guard let url = URL(string: requestConfig.host + requestConfig.path) else {
            throw HTTPError.invalidRequest
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestConfig.method.rawValue
        request.allHTTPHeaderFields = requestConfig.headers
        request.httpBody = httpBody(requestConfig)
        request.timeoutInterval = requestConfig.timeOut
        
        if let urlParameters = requestConfig.parameters, let url = request.url {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            let queryItems = urlParameters.map { URLQueryItem(name: $0.key,
                                                              value: $0.value) }
            urlComponents?.queryItems = queryItems

            if let componentsURL = urlComponents?.url {
                request.url = componentsURL
            }
        }
        
        return request
    }

    private static func httpBody(_ requestConfig: Endpoint) -> Data? {
        guard let parameters = requestConfig.body else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}
