import Foundation

struct MetObject: Identifiable, Codable {
    var id: Int { objectID }
    
    let objectID: Int
    let title: String
    let primaryImage: String
    let primaryImageSmall: String
}
