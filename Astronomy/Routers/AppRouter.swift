//
//  AppRouter.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Observation
import SwiftUI

@Observable @MainActor
final class AppRouter {
    
    enum Root { case tab, onBoarding }
    
    enum Tab: Hashable { case home, feature }
    
    var root: Root = .tab
    let homeRouter = HomeRouter()
    var featureRouter = FeatureRouter()
    
    var selectedTab: Tab = .home
    
    init() {
        homeRouter.appRouter = self
        featureRouter.appRouter = self
    }
    
    func endSession() {
        // 1. Clear ALL stacks before switching root
        homeRouter.path = NavigationPath()
        homeRouter.sheet = nil
        featureRouter.path = NavigationPath()
        
        // 2. Then switch root — view hierarchy tears down cleanly
        root = .onBoarding
    }
}

