import Foundation

struct MetObject: Identifiable, Codable {
    var id: Int { objectID }
    
    let objectID: Int
    let title: String
    let primaryImage: String
    let primaryImageSmall: String
    var isFavorite = false
    
    init(objectID: Int, title: String, primaryImage: String, primaryImageSmall: String) {
        self.objectID = objectID
        self.title = title
        self.primaryImage = primaryImage
        self.primaryImageSmall = primaryImageSmall
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case objectID
        case title
        case primaryImage
        case primaryImageSmall
        case isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectID = try container.decode(Int.self, forKey: .objectID)
        self.title = try container.decode(String.self, forKey: .title)
        self.primaryImage = try container.decode(String.self, forKey: .primaryImage)
        self.primaryImageSmall = try container.decode(String.self, forKey: .primaryImageSmall)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectID, forKey: .objectID)
        try container.encode(title, forKey: .title)
        try container.encode(primaryImage, forKey: .primaryImage)
        try container.encode(primaryImageSmall, forKey: .primaryImageSmall)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
    }
}
