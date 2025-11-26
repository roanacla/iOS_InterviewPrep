import os

public enum Log {
    static let metFeature = Logger(subsystem: "com.roger.prepApp", category: "MetObjects")
    static let feature2 = Logger(subsystem: "com.roger.prepApp", category: "Feature2")
}
