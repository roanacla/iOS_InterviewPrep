//
//  Item.swift
//  iOS_InterviewPrep
//
//  Created by Roger Navarro Claros on 10/13/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
