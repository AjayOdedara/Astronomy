//
//  PersistenceProtocol.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation

protocol PersistenceProtocol {
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func load<T: Codable>(type: T.Type, forKey key: String) -> T?
    func remove(forKey key: String)
    
    func saveData(_ data: Data, forKey key: String)
    func loadData(forKey key: String) -> Data?
    
    func saveString(_ value: String, forKey key: String)
    func loadString(forKey key: String) -> String?
}
