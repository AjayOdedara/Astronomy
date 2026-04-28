//
//  AppContainer.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import Observation

@Observable
final class AppContainer {

    let home: HomeContainer
    
    init() {
        
        // Shared
        let cache = UserDefaultsCache()
        let imageService = ImageService(cache: cache)
        let httpClient = HTTPClient()
        
        // Home
        self.home = HomeContainer(
            httpClient: httpClient,
            cache: cache,
            imageService: imageService
        )
    }
}
