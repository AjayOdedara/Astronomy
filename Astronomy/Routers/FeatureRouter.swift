//
//  FeatureRouter.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Observation
import SwiftUI

@Observable @MainActor
final class FeatureRouter: Identifiable {
    var path: NavigationPath = NavigationPath()
    weak var appRouter: AppRouter?
}
