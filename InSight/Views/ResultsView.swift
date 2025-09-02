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
    @Environment(\.dismiss) private var dismiss
    @Bindable var session: TestSession
    @State private var showingShareSheet = false
    @State private var shareURL: URL?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingRetakeConfirmation = false
    
    var onRetake: () -> Void
    var onComplete: () -> Void // Neuer Parameter
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Deine Stärken")
                    .font(.headline)
                if session.strengths.isEmpty {
                    Text("—")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(session.strengths, id: \.self) {
                        Text("• \($0)")
                    }
                }
                
                Text("Empfehlungen")
                    .font(.headline)
                    .padding(.top, 8)
                if session.suggestions.isEmpty {
                    Text("—")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(session.suggestions, id: \.self) {
                        Text("• \($0)")
                    }
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
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                // Prominent Save Button
                Button(action: saveToDatabase) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Ergebnisse speichern")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Secondary Actions
                HStack(spacing: 12) {
                    ShareLink(item: session.resultsSummary) {
                        Label("Teilen", systemImage: "square.and.arrow.up")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Als Datei exportieren") {
                        exportAsFile()
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .buttonStyle(.bordered)
                    
                    Button("Test wiederholen") {
                        showingRetakeConfirmation = true
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)
            .background(.regularMaterial, ignoresSafeAreaEdges: .bottom)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let shareURL = shareURL {
                ActivityViewController(activityItems: [shareURL])
            }
        }
        .alert("Info", isPresented: $showingAlert) {
            Button("OK") {
                if alertMessage.contains("erfolgreich") {
                    dismiss() // Schließt die ResultsView
                    onComplete() // Schließt die QuestionFlowView
                }
            }
        } message: {
            Text(alertMessage)
        }
        .confirmationDialog("Test wiederholen?", isPresented: $showingRetakeConfirmation) {
            Button("Ja, Test wiederholen", role: .destructive) {
                onRetake()
            }
            Button("Abbrechen", role: .cancel) { }
        } message: {
            Text("Möchten Sie wirklich einen neuen Test starten? Ihre aktuellen Eingaben gehen dabei verloren.")
        }
    }
    
    private func saveToDatabase() {
        do {
            // Simply insert the session - SwiftData will handle duplicates
            modelContext.insert(session)
            try modelContext.save()
            
            alertMessage = "Ergebnisse erfolgreich gespeichert!"
            showingAlert = true
            
        } catch {
            alertMessage = "Fehler beim Speichern: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func exportAsFile() {
        do {
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileName = "InSight_\(session.title)_\(Date().formatted(.iso8601.year().month().day())).testinsight"
            let tempURL = tempDirectory.appendingPathComponent(fileName)
            
            let codableSession = session.toCodable()
            let data = try JSONEncoder().encode(codableSession)
            try data.write(to: tempURL)
            
            shareURL = tempURL
            showingShareSheet = true
            
        } catch {
            alertMessage = "Fehler beim Exportieren: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
