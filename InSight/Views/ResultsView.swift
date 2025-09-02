//
//  ResultsView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI
import SwiftData

struct ResultsView: View {
    @Environment(\.modelContext) private var modelContext
    @State var session: TestSession
    var onRetake: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Deine Stärken")
                        .font(.headline)
                    if session.strengths.isEmpty {
                        Text("–")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(session.strengths, id: \.self) { Text("• \($0)") }
                    }

                    Text("Empfehlungen")
                        .font(.headline)
                        .padding(.top, 8)
                    if session.suggestions.isEmpty {
                        Text("–")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(session.suggestions, id: \.self) { Text("• \($0)") }
                    }

                    Text("Eigene Notiz")
                        .font(.headline)
                        .padding(.top, 8)
                    TextField("Optional…", text: Binding(
                        get: { session.note ?? "" },
                        set: { session.note = $0 }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                .padding()
            }
            .navigationTitle("Ergebnisse")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        ShareLink(item: session.resultsSummary) {
                            Label("Teilen", systemImage: "square.and.arrow.up")
                        }
                        Spacer()
                        Button("Speichern") {
                            try? modelContext.save()
                        }
                        .buttonStyle(.bordered)
                        Button("Test wiederholen") {
                            onRetake()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
}
