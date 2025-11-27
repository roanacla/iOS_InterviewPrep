import Foundation

struct CatalogItem: Codable, Identifiable {
    var id: Int
    var title: String
    var artist: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case title = "trackName"
        case artist = "artistName"
    }
}
