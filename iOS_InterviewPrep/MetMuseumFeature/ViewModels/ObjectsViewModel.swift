import Foundation

@MainActor
@Observable
class ObjectsViewModel {
    var metObjects: [MetObject] = []
    var networkService: MetNetworkService
    var isErrorPresented = false
    var alertMessage = "Something went wrong"
    var searchQuery = ""
    var limit = 10
    var firstLoadReady = false
    
    init(networkService: MetNetworkService) {
        self.networkService = networkService
    }
    
    func searchObjects() async {
        do {
            let searchResult = try await networkService.fetchObjects(query: searchQuery.isEmpty ? "roge" : searchQuery)
            
            var fetchObjects: [(Int, MetObject)] = []
            
            try await withThrowingTaskGroup(of: (Int, MetObject).self) { group in
                for (id, value) in searchResult.objectIDs.prefix(limit).enumerated() {
                    group.addTask {
                        let metObject = try await self.fetchObject(id: value)
                        return (id, metObject)
                    }
                }
                
                for try await(idx, object) in group {
                    fetchObjects.append((idx, object))
                }
            }
            
            metObjects = fetchObjects.sorted { $0.0 < $1.0 }.map { $0.1 }
            firstLoadReady = true
        } catch {
            firstLoadReady = false
            isErrorPresented = true
            metObjects = []
            
            if let error = (error as? MetSearchError) {
                switch error {
                case .invalidResponse:
                    alertMessage = "Invalid response"
                case .invalidURL:
                    alertMessage = "Invalid URL"
                }
            } else if let error = (error as? DecodingError) {
                alertMessage = "Decoding error: \(error.localizedDescription)"
            } else {
                alertMessage = error.localizedDescription.description
            }
        }
    }
    
    private func fetchObject(id: Int) async throws -> MetObject {
        return try await networkService.fetchObject(endpoint: "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(id)")
    }
}
