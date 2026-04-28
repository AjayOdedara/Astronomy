//
//  MockCache.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

@testable import Astronomy
import Foundation

final class MockCache: PersistenceProtocol {
    private var storage: [String: Data] = [:]
    private var rawStorage: [String: Data] = [:]
    private var strStorage: [String: String] = [:]
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T: Codable>(_ value: T, forKey key: String) throws {
        storage[key] = try encoder.encode(value)
    }
    
    func load<T: Codable>(type: T.Type, forKey key: String) -> T? {
        guard let data = storage[key] else { return nil }
        return try? decoder.decode(type, from: data)
    }
    
    func remove(forKey key: String) { storage.removeValue(forKey: key) }
    func saveData(_ data: Data, forKey key: String) { rawStorage[key] = data }
    func loadData(forKey key: String) -> Data? { rawStorage[key] }
    func saveString(_ value: String, forKey key: String) { strStorage[key] = value }
    func loadString(forKey key: String) -> String? { strStorage[key] }
}
