//
//  HomeView.swift
//  Astronomy
//
//  Created by Ajay Odedara on 26/04/2026.
//

import SwiftUI

struct HomeView: View {
    @Bindable var router: HomeRouter
    @State var viewModel: HomeViewModel
    let imageService: any ImageServiceProtocol

    @State private var selectedDate = Date.now

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationTitle("APOD")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { router.showDatePicker() }
                        label: { Image(systemName: "calendar") }
                            .accessibilitySpeak(HomeAccessibility.Speak.calendarButton)
                    }
                    
                }
                .sheet(item: $router.sheet) { sheet in
                    switch sheet {
                    case .datePicker:
                        DatePickerSheet(selectedDate: $selectedDate,
                                        buttonTitle: "Fetch APOD") {
                            router.dismiss()
                            Task { await viewModel.fetchAPOD(for: .single(date: selectedDate)) }
                        } onCancel: {
                            router.dismiss()
                        }
                    }
                }
        }
        .task { await viewModel.onAppear() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.apodState {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let source):
            switch source {
            case .fresh(let entry):
                APODContentView(entry: entry, imageService: imageService)
            case .cached(let entry, _):
                VStack(spacing: 0) {
                    CachedBanner { Task { await viewModel.onRetry() } }
                    APODContentView(entry: entry, imageService: imageService)
                }
            }

        case .error(let error):
            ErrorView(message: error.localizedDescription) {
                Task { await viewModel.onRetry() }
            }
        }
    }
}

#Preview {
    HomeView(
        router: HomeRouter(),
        viewModel: HomeViewModel(
            homeService: APODRepository(
                httpClient: HTTPClient(),
                cache: UserDefaultsCache()
            )
        ), imageService: ImageService(cache: UserDefaultsCache())
    )
}
