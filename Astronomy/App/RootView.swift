//
//  RootView.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import SwiftUI
import Observation

struct RootView: View {
    @Environment(AppRouter.self) var router
    @Environment(AppContainer.self) private var container
    
    var body: some View {
        switch router.root {
        case .tab:
            AppTabView()
                .environment(router)
                .environment(container)
        case .onBoarding:
            Text("On Boarding View")
        }
    }
}

#Preview {
    RootView()
}
