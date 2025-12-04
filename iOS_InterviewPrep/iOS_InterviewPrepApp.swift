//
//  iOS_InterviewPrepApp.swift
//  iOS_InterviewPrep
//
//  Created by Roger Navarro Claros on 10/13/25.
//

import SwiftUI
import SwiftData

@main
struct iOS_InterviewPrepApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        registerDependencies()
    }

    var body: some Scene {
        WindowGroup {
            ConceptsView(viewModel: .init())
        }
        .modelContainer(sharedModelContainer)
    }

    private func registerDependencies() {
        // Register the concrete ITunesCatalogService for the MusicCatalogServiceProtocol.
        let musicService: MusicCatalogServiceProtocol = ITunesCatalogService()
        DependencyContainer.shared.register(MusicCatalogServiceProtocol.self, object: musicService)

        // Register the concrete MetNetworkService for its protocol.
        // NOTE: I'm assuming the protocol is named MetNetworkServiceProtocol. Please adjust if it's different.
        let metService = MetNetworkService() // Assuming a protocol exists for this.
        DependencyContainer.shared.register(MetNetworkService.self, object: metService)
        
        // ... register other services here
    }
}
