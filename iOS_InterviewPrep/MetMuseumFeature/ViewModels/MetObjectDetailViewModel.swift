import Foundation

@Observable
@MainActor
public class MetObjectDetailViewModel {
    var metObject: MetObject
    
    init(metObject: MetObject) {
        self.metObject = metObject
    }
    
    func toggleFavorite() {
        metObject.isFavorite.toggle()
    }
}
