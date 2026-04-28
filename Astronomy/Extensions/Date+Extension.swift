//
//  Date+Extension.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

import Foundation

extension Date {
    var apodString: String {
        formatted(.iso8601.year().month().day())
    }
}
