//
//  MainTabView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Query(sort: \TestSession.createdAt, order: .reverse) var sessions: [TestSession]
    @State private var selectedTab = 0
    @State private var showingTest = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                LaunchView(onStartTest: {
                    showingTest = true
                })
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
                    
            }
            .tag(0)
            
            NavigationStack {
                ResultsListView()
            }
            .tabItem {
                Image(systemName: "list.clipboard.fill")
                Text("Ergebnisse")
                if !sessions.isEmpty {
                    Text("\(sessions.count)")
                }
            }
            .tag(1)
        }
        .onAppear {
            // Show Results tab by default if there are saved assessments
            if !sessions.isEmpty {
                selectedTab = 1
            }
        }
        .fullScreenCover(isPresented: $showingTest) {
            NavigationStack {
                QuestionFlowView {
                    showingTest = false
                    selectedTab = 1 // Switch to Results tab after completing test
                }
            }
        }
    }
}
