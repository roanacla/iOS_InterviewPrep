import SwiftUI

struct NetworkingView: View {
    let concept: Concept
    let viewModel: NetworkingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .center) {
                Image(uiImage: viewModel.artwork)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 100, height: 100)
                  .shadow(radius: 10)
                if let artistName = viewModel.song?.artistName {
                    Text(artistName)
                        .font(.caption)
                        .bold()
                }
                if let trackName = viewModel.song?.trackName {
                    Text(trackName)
                        .font(.caption)
                }
            }
        }
        .padding()
        .navigationTitle(concept.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.downloadSong()
        }
    }
}

struct NetworkingView_Previews: PreviewProvider {
    static var previews: some View {
        let concept: Concept = .init(title: "Networking", description: "Fetching and sending data from and to a server", subject: .networking)
        NetworkingView(concept: concept, viewModel: NetworkingViewModel(songDownloader: .init()))
    }
}
