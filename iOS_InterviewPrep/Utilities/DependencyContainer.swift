import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    private var singletonDictionary: [String: Any] = [:]
    private var factoryDictionary: [String: Any] = [:]
    
    private init() {}
    
    // Register using the type as the key.
    func register<T>(_ type: T.Type, object: Any) {
        let key = String(describing: type)
        singletonDictionary[key] = object
    }
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
            let key = String(describing: type)
            factoryDictionary[key] = factory
        }
    
    // Resolve using the type. This is now much safer.
    // If the dependency is not found, it's a programmer error, so we crash.
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        if let factory = factoryDictionary[key] as? () -> T {
            return factory() // CRITICAL: This executes the closure and returns a NEW instance
        }
        
        guard let dependency = singletonDictionary[key] as? T else {
            fatalError("Failed to resolve dependency for type \(key)")
        }
        return dependency
    }
}
