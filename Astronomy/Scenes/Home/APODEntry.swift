//
//  APODEntry.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Foundation

struct APODEntry: Codable {
    
    enum CodingKeys: String, CodingKey {
        case date, title, url
        case mediaType = "media_type"
        case description = "explanation"
    }
    
    let date: String
    let title: String
    let description: String
    let mediaType: MediaType
    let url: String
}

enum MediaType: String, Codable {
    case image
    case video
}
