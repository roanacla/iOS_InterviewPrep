import Foundation

public final class AsyncDictionary<Key: Hashable, Value> {
    private let queue = DispatchQueue(label: "com.roger.asyncDict", attributes: .concurrent)
    private var storage: [Key: Value]

    public init(_ initial: [Key: Value] = [:]) { self.storage = initial }

    /// Asynchronous write (exclusive via barrier)
    public func setValue(_ value: Value, forKey key: Key, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            self.storage[key] = value
            completion?()
        }
    }
    
    /// Asynchronous delete
    public func removeValue(forKey key: Key,
                            deliverOn resultQueue: DispatchQueue = .main,
                            completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            _ = self.storage.removeValue(forKey: key)
            guard let completion else { return }
            resultQueue.async(execute: completion)
        }
    }

    /// Asynchronous read (parallel with other reads)
    public func getValue(for key: Key,
                         deliverOn resultQueue: DispatchQueue = .main,
                         completion: @escaping (Value?) -> Void) {
        queue.async {
            let value = self.storage[key]
            resultQueue.async { completion(value) }
        }
    }
}
