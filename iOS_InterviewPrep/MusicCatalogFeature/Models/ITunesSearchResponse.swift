import Foundation

struct ITunesSearchResponse: Codable {
    let resultCount: Int
    let results: [CatalogItem]
}
