//
//  AppTabView.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import SwiftUI

struct AppTabView: View {
    @Environment(AppRouter.self) var appRouter
    @Environment(AppContainer.self) private var container
    
    var body: some View {
        TabView(selection: Bindable(appRouter).selectedTab) {
            Tab("Home",
                systemImage: "house",
                value: AppRouter.Tab.home) {
                
                HomeView(
                    router: appRouter.homeRouter,
                    viewModel: container.home.viewModel,
                    imageService: container.home.imageService
                )
                .environment(appRouter)
            }
            Tab("Feature", systemImage: "heart", value: AppRouter.Tab.feature) { }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
