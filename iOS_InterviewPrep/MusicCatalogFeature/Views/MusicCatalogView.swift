import SwiftUI

struct MusicCatalogView: View {
    @Bindable var viewModel: MusicCatalogViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List(viewModel.items) { item in
                    Text(item.title)
                }
            }
        }
        .navigationTitle("Music Catalog")
        .searchable(text: $viewModel.searchText)
        .task(id: viewModel.searchText) {
            if viewModel.searchText.isEmpty {
                viewModel.items = []
                return
            }
            
            do {
                try await Task.sleep(for: .seconds(0.8))
                await viewModel.searchMusic()
            } catch { }
        }
    }
}

#Preview {
    MusicCatalogView(viewModel: MusicCatalogViewModel(musicCatalogService: ITunesCatalogService()))
}
