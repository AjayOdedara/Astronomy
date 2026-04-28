//
//  HomeContainer.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

final class HomeContainer {
    let viewModel: HomeViewModel
    let imageService: any ImageServiceProtocol
    
    init(
        httpClient: HTTPClientProtocol,
        cache: any PersistenceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.imageService = imageService
        let repository = APODRepository(
            httpClient: httpClient,
            cache: cache
        )
        self.viewModel = HomeViewModel(homeService: repository)
    }
}
