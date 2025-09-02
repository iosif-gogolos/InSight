//
//  ResultsListView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI
import SwiftData

struct ResultsListView: View {
    @Query(sort: \TestSession.createdAt, order: .reverse) var sessions: [TestSession]

    var body: some View {
        List {
            ForEach(sessions) { s in
                NavigationLink(value: s) {
                    VStack(alignment: .leading) {
                        Text(s.title).font(.headline)
                        Text(s.createdAt, style: .date).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Ergebnisse")
        .toolbar {
            NavigationLink("+ Neuer Test") { QuestionFlowView() }
        }
        .navigationDestination(for: TestSession.self) { s in
            ResultsView(session: s, onRetake: { /* optional: nichts, weil aus Historie */ })
        }
    }
}
