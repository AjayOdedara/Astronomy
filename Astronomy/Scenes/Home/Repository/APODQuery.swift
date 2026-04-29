//
//  APODQuery.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation

enum APODQuery: Equatable {
    case today
    case single(date: Date)

    var parameters: [String: String] {
        var params: [String: String] = ["api_key": Config.nasaAPIKey]
        switch self {
        case .today:
            break
        case .single(let date):
            params["date"] = date.localDateString
        }
        return params
    }
}
