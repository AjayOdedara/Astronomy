//
//  UserDefaultsCache.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation

final class UserDefaultsCache: PersistenceProtocol {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save<T: Codable>(_ value: T, forKey key: String) throws {
        let data = try encoder.encode(value)
        defaults.set(data, forKey: key)
    }

    func load<T: Codable>(type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    func saveData(_ data: Data, forKey key: String) {
        defaults.set(data, forKey: key)
    }

    func loadData(forKey key: String) -> Data? {
        defaults.data(forKey: key)
    }
    
    func saveString(_ value: String, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func loadString(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }
}
