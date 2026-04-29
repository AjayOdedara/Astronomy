//
//  Date+Extension.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation

extension Date {
    var localDateString: String {
        let style = Date.ISO8601FormatStyle(timeZone: .current)
        return formatted(style.year().month().day())
    }
}
