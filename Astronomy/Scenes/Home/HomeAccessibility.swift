//
//  HomeAccessibility.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

enum HomeAccessibility {
    enum Speak: String {
        case calendarButton   = "Select date"
        case cachedBanner     = "Showing cached result"
        case videoUnavailable = "Video content is unavailable"
        
        // CacheBannerView Identifiers
        case cancelButton  = "Cancel"
        case confirmButton = "Fetch APOD"
        case datePicker    = "Date selector"
    }
    
    // ├── Hint         → extra VoiceOver context    (if needed)
    // └── Identifier   → UI test identifiers        (if needed)
}
