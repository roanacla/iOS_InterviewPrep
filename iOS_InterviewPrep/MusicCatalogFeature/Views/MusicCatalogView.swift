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
        .onSubmit(of: .search) {
            Task {
                await viewModel.searchMusic()
            }
        }
        .task {
            await viewModel.searchMusic()
        }
    }
}

#Preview {
    MusicCatalogView(viewModel: MusicCatalogViewModel(musicCatalogService: ITunesCatalogService()))
}
