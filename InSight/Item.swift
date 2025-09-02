//
//  Item.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
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
