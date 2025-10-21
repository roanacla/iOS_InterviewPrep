import SwiftUI

enum SongDownloaderError: Error {
    case invalidResponse
    case dataConversionError
    case invalidTrackID
    case errorDecodingSong
    case zeroResults
}

class SongDownloader {
    private let session: URLSession
    private let sessionConfiguration: URLSessionConfiguration
    
    init() {
        self.sessionConfiguration = .default
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    enum ItunesEndPoint: String {
        case getTrackById = "https://itunes.apple.com/lookup?id="

    }
    
    func downloadArtwork(for url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw SongDownloaderError.invalidResponse
        }
        
        do {
            return try data
        } catch {
            throw SongDownloaderError.dataConversionError
        }
    }
    
    func downloadSong(for trackId: String) async throws -> Song {
        guard let trackURL = URL(string: ItunesEndPoint.getTrackById.rawValue + trackId) else {
            throw SongDownloaderError.invalidTrackID
        }
        
        let (data, response) = try await session.data(from: trackURL)
        
        guard let response = (response as? HTTPURLResponse), response.statusCode == 200 else {
            throw SongDownloaderError.invalidResponse
        }
        
        do {
            let songResults = try JSONDecoder().decode(SongResults.self, from: data)
            guard songResults.results.count > 0, let song = songResults.results.first else {
                throw SongDownloaderError.zeroResults
            }
            return song
        } catch {
            throw SongDownloaderError.errorDecodingSong
        }
    }
}
