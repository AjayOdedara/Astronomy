//
//  Endpoint.swift
//  APOD
//
//  Created by Ajay Odedara on 26/04/2026.
//

enum HTTPMethod: String {
    case get = "GET"
}

public enum Config {
    public static let planetary: String = "https://api.nasa.gov/planetary/"
    public static let nasaAPIKey: String = "DEMO_KEY"
}

protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
    var parameters: [String: String]? { get }
    var timeOut: Double { get }
}

extension Endpoint {
    
    var body: [String: Any]? { nil }
    var parameters: [String: Any]? { nil }
    
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    
    var host: String { Config.planetary }
  
    var timeOut: Double { 30.0 }
}
