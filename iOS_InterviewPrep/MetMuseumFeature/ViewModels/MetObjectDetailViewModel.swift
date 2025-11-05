import Foundation
import UIKit

@Observable
@MainActor
public class MetObjectDetailViewModel {
    var metObject: MetObject
    var nsCache: NSCache<NSNumber, UIImage>
    
    init(metObject: MetObject, cache: NSCache<NSNumber, UIImage>) {
        self.metObject = metObject
        self.nsCache = cache
    }
    
    func toggleFavorite() {
        metObject.isFavorite.toggle()
    }
}
