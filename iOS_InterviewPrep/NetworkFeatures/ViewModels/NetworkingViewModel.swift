import SwiftUI

@MainActor
@Observable
class NetworkingViewModel {
    private let songDownloaderService: SongDownloader
    var song: Song?
    var artwork = UIImage()
    
    init(songDownloader: SongDownloader) {
        self.songDownloaderService = songDownloader
    }
    
    private func downloadSongArtwork() async {
        guard let song else { return }
        do {
            guard let artworkUrl = URL(string: song.artworkUrl100) else { return }
            let artworkData = try await songDownloaderService.downloadArtwork(for: artworkUrl)
            self.artwork = UIImage(data: artworkData) ?? UIImage()
        } catch {
            print(error)
        }
    }
    
    func downloadSong() async {
        do {
            let song = try await songDownloaderService.downloadSong(for: "1789396237")
            self.song = song
            await downloadSongArtwork()
        } catch {
            print(error)
        }
    }
}
