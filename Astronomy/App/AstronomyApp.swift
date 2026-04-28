//
//  AstronomyApp.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import SwiftUI

@main
struct AstronomyApp: App {
    @State private var router = AppRouter()
    @State private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .environment(container)
        }
    }
}
