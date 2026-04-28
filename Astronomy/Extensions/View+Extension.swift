//
//  View.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import SwiftUI

extension View {
    func accessibilitySpeak<T: RawRepresentable>(_ label: T) -> some View where T.RawValue == String {
        accessibilityLabel(label.rawValue)
    }
}
