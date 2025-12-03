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
                try await Task.sleep(for: .seconds(0.5))
                await viewModel.searchMusic()
            } catch { }
        }
        .alert(
            "Error",
            isPresented: .init(
                get: { viewModel.presentedError != nil },
                set: { if !$0 { viewModel.presentedError = nil } }
            ),
            presenting: viewModel.presentedError
        ) { _ in
            Button("OK") {}
        } message: { error in
            Text(error.rawValue)
        }
    }
}

#Preview {
    MusicCatalogView(viewModel: MusicCatalogViewModel(musicCatalogService: ITunesCatalogService()))
}
