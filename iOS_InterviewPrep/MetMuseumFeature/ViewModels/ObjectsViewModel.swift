import Foundation
import SwiftUI

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
    var nsCache: NSCache<NSNumber, UIImage> = .init()
    
    init(networkService: MetNetworkService) {
        self.networkService = networkService
    }
    
    func saveImageInCache(id: Int, image: UIImage) {
        let imageId = NSNumber(value: id)
        nsCache.setObject(image, forKey: imageId)
    }
    
    func searchObjects() async {
        do {
            let searchResult = try await networkService.fetchObjects(query: searchQuery.isEmpty ? "roge" : searchQuery)
            
            var fetchObjects: [MetObject?] = Array(repeating: nil, count: searchResult.objectIDs.count)
            
            try await withThrowingTaskGroup(of: (Int, MetObject)?.self) { group in
                for (id, value) in searchResult.objectIDs.prefix(limit).enumerated() {
                    group.addTask { [weak self, nsCache] in
                        guard let self else { return nil }
                        let metObject = try await self.fetchObject(id: value)
                        if nsCache.object(forKey: NSNumber(value:metObject.objectID)) == nil {
                            if let image = try await self.fetchImage(url: metObject.primaryImageSmall) {
                                await saveImageInCache(id: metObject.objectID, image: image)
                            }
                        }
                        return (id, metObject)
                    }
                }
                
                for try await (idx, object) in group.compactMap({$0}) {
                    fetchObjects[idx] = object
                }
            }
            
            metObjects = fetchObjects.compactMap { $0 }
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
    
    private func fetchImage(url: String) async throws -> UIImage? {
        return try await networkService.fetchObjectImage(endpoint: url)
    }
}
