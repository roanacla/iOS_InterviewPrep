import Foundation

struct Song: Codable {
    let trackId: Int
    let artistName: String
    let artworkUrl100: String
    let collectionName: String
    let previewUrl: String
    let trackName: String
    
    var isDownloading = false
    var downloadLocation: URL?
    var localFile: URL?
    var previewURL: URL? {
        return URL(string: previewUrl)
    }
    
    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case trackId
        case artistName
        case artworkUrl100
        case collectionName
        case previewUrl
        case trackName
    }
    
    // MARK: Initialization
    init(trackId: Int, artistName: String, artworkUrl100: String, collectionName: String, previewUrl: String, trackName: String) {
        self.trackId = trackId
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.collectionName = collectionName
        self.previewUrl = previewUrl
        self.trackName = trackName
    }
}
