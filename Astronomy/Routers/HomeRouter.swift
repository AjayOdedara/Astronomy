//
//  HomeRouter.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import Observation
import SwiftUI

@Observable @MainActor
final class HomeRouter: Identifiable {
    var path: NavigationPath = NavigationPath()
    
    var sheet: HomeSheetRoute? = nil
    weak var appRouter: AppRouter?
    
    
    func showDatePicker() {
        sheet = .datePicker
    }
    
    func dismiss() {
        sheet = nil
    }
}

// HomeSheetRoute.swift — screens that appear as sheets
enum HomeSheetRoute: Identifiable {
    case datePicker

    var id: String {  // Identifiable required for .sheet(item:)
        switch self {
            case .datePicker:  return "datePicker"
        }
    }
}
