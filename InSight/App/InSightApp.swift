//
//  InSightApp.swift
//  InSight
//
//  Created by Iosif Gogolos on 01.09.25.
//

import SwiftUI
import SwiftData

@main
struct InSightApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Question.self, TestSession.self, Item.self])
    }
}
