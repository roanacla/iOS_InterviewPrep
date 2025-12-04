import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    private var dictionary: [String: Any] = [:]
    
    private init() {}
    
    // Register using the type as the key.
    func register<T>(_ type: T.Type, object: Any) {
        let key = String(describing: type)
        dictionary[key] = object
    }
    
    // Resolve using the type. This is now much safer.
    // If the dependency is not found, it's a programmer error, so we crash.
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let dependency = dictionary[key] as? T else {
            fatalError("Failed to resolve dependency for type \(key)")
        }
        return dependency
    }
}
