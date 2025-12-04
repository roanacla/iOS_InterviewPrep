import Testing
@testable import iOS_InterviewPrep // Replace with your actual module name if different

// A mock error to use in tests
private enum MockError: Error {
    case generic
}

// A mock service to simulate network responses without making actual network calls.
// Using a Result type allows us to easily configure it for success or failure.
private class MockMusicCatalogService: MusicCatalogServiceProtocol {
    var searchResult: Result<[CatalogItem], Error> = .success([])
    
    func search(term: String) async throws -> [CatalogItem] {
        return try searchResult.get()
    }
}

@Suite("MusicCatalogViewModel Tests")
struct MusicCatalogViewModelTests {
    
    private var viewModel: MusicCatalogViewModel!
    private var mockMusicCatalogService: MockMusicCatalogService!
    
    // By annotating init with @MainActor, we ensure the setup code runs
    // on the main thread, which is required by the @Observable macro's
    // underlying implementation and prevents the crash.
    @MainActor
    init() {
        mockMusicCatalogService = MockMusicCatalogService()
        viewModel = MusicCatalogViewModel(musicCatalogService: mockMusicCatalogService)
    }
    
    @Test("Searching for music succeeds and updates items")
    func searchMusicSucceeds() async throws {
        // Arrange: Define the expected successful result.
        let expectedItems = [
            CatalogItem(id: 1, title: "Style", artist: "Taylor Swift"),
            CatalogItem(id: 2, title: "Blank Space", artist: "Taylor Swift")
        ]
        mockMusicCatalogService.searchResult = .success(expectedItems)
        
        // Act: Call the method to be tested.
        await viewModel.searchMusic()
        
        // Assert: First, await to get the properties from the MainActor-isolated view model.
        let resultingItems = await viewModel.items
        let isLoading = await viewModel.isLoading
        let presentedError = await viewModel.presentedError
        
        // Then, perform synchronous assertions on the local constants.
        #expect(isLoading == false, "isLoading should be false after the search completes.")
        #expect(resultingItems.count == 2, "There should be 2 items.")
        #expect(resultingItems.first?.title == "Style", "The first item's title should be 'Style'.")
        #expect(presentedError == nil, "No error should be presented on success.")
    }
    
    @Test("Searching for music fails and presents an error")
    func searchMusicFails() async throws {
        // Arrange: Configure the mock service to throw an error.
        mockMusicCatalogService.searchResult = .failure(MockError.generic)
        
        // Act: Call the method to be tested.
        await viewModel.searchMusic()
        
        // Assert: Get the properties from the view model.
        let resultingItems = await viewModel.items
        let isLoading = await viewModel.isLoading
        let presentedError = await viewModel.presentedError
        
        // Perform assertions.
        #expect(isLoading == false, "isLoading should be false after the search completes.")
        #expect(resultingItems.isEmpty, "Items should be empty on failure.")
        #expect(presentedError == .networkIssue, "A network issue error should be presented.")
    }
}
