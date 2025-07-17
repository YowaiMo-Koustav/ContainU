//
//  Item.swift
//  ContainU
//
//  Created by KOUSTAV MALLICK on 17/07/25.
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
