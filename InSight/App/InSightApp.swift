//
//  InSightApp.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI
import SwiftData

@main
struct InSightApp: App {
    var body: some Scene {
        #if os(iOS) || os(macOS)
        DocumentGroup(editing: ResultsView.self, contentType: UTType){
            
        }
        #else
        WindowGroup {
            NavigationStack {
                ResultsListView()
            }
            .modelContainer(for: [Question.self, TestSession.self])
            #endif
        }
    }
}
