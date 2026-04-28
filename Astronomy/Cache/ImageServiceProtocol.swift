//
//  ImageServiceProtocol.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation
import UIKit

/// ImageService "last request only" behavior is explicit and coordinate it with the cached APOD entry so text and image cannot mismatch.
/// service can be improved for per key/image cache or we can wrap in a last image store service as well to be more explicit.

enum ImageServiceError: Error {
    case invalidData
    case invalidURL
}

protocol ImageServiceProtocol {
    func image(for urlString: String) async throws -> UIImage
}

final class ImageService: ImageServiceProtocol {

    private let memoryCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 50 * 1024 * 1024
        return cache
    }()

    private let session: URLSession
    private let cache: any PersistenceProtocol
    
    private static let lastOnlyKey = "last_image_key"
    private static let lastImageURLKey = "apod_last_image_url"

    init(
        session: URLSession = .apodImageSession,
        cache: any PersistenceProtocol,
    ) {
        self.session = session
        self.cache = cache
    }

    func image(for urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageServiceError.invalidURL
        }
        let memoryKey = url.absoluteString as NSString
        
        if let image = fromMemory(key: memoryKey) { return image }
        
        do {
            let (image, data) = try await fromNetwork(url: url)
            cache.saveData(data, forKey: Self.lastOnlyKey)
            cache.saveString(url.absoluteString, forKey: Self.lastImageURLKey)  // ← save alongside
            store(image, forKey: memoryKey)
            return image
        } catch {
            if let image = fromDiskFallback(for: url) {       // ← now URL-aware
                store(image, forKey: memoryKey)
                return image
            }
            throw error
        }
    }

    private func fromDiskFallback(for url: URL) -> UIImage? {
        guard
            let cachedURLString = cache.loadString(forKey: Self.lastImageURLKey),
            cachedURLString == url.absoluteString,            // ← must match, no stale returns
            let data = cache.loadData(forKey: Self.lastOnlyKey)
        else { return nil }
        return UIImage(data: data)
    }


    private func fromMemory(key: NSString) -> UIImage? {
        memoryCache.object(forKey: key)
    }
    
    private func fromNetwork(url: URL) async throws -> (UIImage, Data) {
        let (data, _) = try await session.data(from: url)
        guard let image = UIImage(data: data) else { throw ImageServiceError.invalidData }
        return (image, data)
    }

    private func store(_ image: UIImage, forKey key: NSString) {
        let cost = image.cgImage.map { $0.bytesPerRow * $0.height } ?? 0
        memoryCache.setObject(image, forKey: key, cost: cost)
    }
}

extension ImageService {
    enum CacheMode {
        case lastOnly
        case perKey
    }
}

extension URLSession {
    static let apodImageSession: URLSession = {
        let cache = URLCache(
            memoryCapacity: 10 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024
        )
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        return URLSession(configuration: config)
    }()
}
