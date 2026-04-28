//
//  HomeViewModel.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//
import Foundation

@Observable @MainActor
class HomeViewModel {
    
    private let homeService: APODRepositoryProtocol
    
    private var currentQuery: APODQuery = .today
    private(set) var apodState: ViewState<DataSource<APODEntry>> = .idle
    
    var shouldFetch: Bool{
        if case .idle = apodState { return true }
        return false
    }
    
    init(homeService: APODRepositoryProtocol) {
        self.homeService = homeService
    }
    
    func onAppear(for query: APODQuery = .today) async {
        guard shouldFetch else { return }
        await fetch(for: query)
    }
    
    func onRetry() async {
        await fetch(for: currentQuery)
    }
    
    func fetchAPOD(for query: APODQuery) async {
        guard currentQuery != query else { return }
        await fetch(for: query)
    }
    
    private func fetch(for query: APODQuery) async {
        currentQuery = query
        apodState = .loading
        do {
            let apodEntry = try await homeService.astronomy(for: query)
            apodState = .loaded(apodEntry)
        } catch {
            apodState = .error(error)
        }
    }
}
