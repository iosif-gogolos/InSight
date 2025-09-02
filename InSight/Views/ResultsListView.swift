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
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewTest = false

    var body: some View {
        VStack {
            if sessions.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                    
                    VStack(spacing: 8) {
                        Text("Noch keine Tests vorhanden")
                            .font(.headline)
                        
                        Text("Starten Sie Ihren ersten Persönlichkeitstest, um Ihre Ergebnisse hier zu sehen.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        showingNewTest = true
                    } label: {
                        Label("Ersten Test starten", systemImage: "play.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Liste mit Ergebnissen
                List {
                    ForEach(sessions) { session in
                        NavigationLink(value: session) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(session.title)
                                    .font(.headline)
                                
                                HStack {
                                    Text(session.createdAt, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                    
                                    if !session.strengths.isEmpty {
                                        Text("\(session.strengths.count) Stärken")
                                            .font(.caption2)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(.green.opacity(0.2))
                                            .foregroundColor(.green)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .onDelete(perform: deleteSessions)
                }
                .listStyle(.plain)
                .refreshable {
                    // Refresh functionality
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }
            }
            
            // Bottom Button (immer sichtbar wenn Liste nicht leer ist)
            if !sessions.isEmpty {
                VStack {
                    Divider()
                    
                    Button {
                        showingNewTest = true
                    } label: {
                        Label("Neuer Test", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(.regularMaterial)
            }
        }
        .navigationTitle("Ergebnisse")
        .onAppear {
            print("ResultsListView appeared - Sessions count: \(sessions.count)")
            for session in sessions {
                print("Found session: \(session.title) - Created: \(session.createdAt)")
            }
        }
        .navigationDestination(for: TestSession.self) { session in
            ResultsView(
                session: session,
                onRetake: {
                    showingNewTest = true
                }
            ) {
                // onComplete - do nothing when viewing historical results
            }
        }
        .fullScreenCover(isPresented: $showingNewTest) {
            NavigationStack {
                QuestionFlowView {
                    showingNewTest = false
                    // Stay on Results tab after completing new test
                }
            }
        }
    }
    
    private func deleteSessions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(sessions[index])
                do {
                    try modelContext.save()
                } catch {
                    print("Error deleting session: \(error)")
                }
            }
        }
    }
}
