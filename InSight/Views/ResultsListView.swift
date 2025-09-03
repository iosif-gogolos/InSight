import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ResultsListView: View {
    @Query(sort: \TestSession.createdAt, order: .reverse) var sessions: [TestSession]
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewTest = false
    @State private var showingImportPicker = false
    @State private var importAlert = false
    @State private var importMessage = ""

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
                    // Force refresh der Query
                    try? await Task.sleep(nanoseconds: 100_000_000)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Alle exportieren", systemImage: "square.and.arrow.up") {
                        exportAllSessions()
                    }
                    .disabled(sessions.isEmpty)
                    
                    Button("Test importieren", systemImage: "square.and.arrow.down") {
                        showingImportPicker = true
                    }
                    
                    Button("Aktualisieren", systemImage: "arrow.clockwise") {
                        refreshData()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            print("📱 ResultsListView appeared - Sessions count: \(sessions.count)")
            for session in sessions {
                print("📱 Found session: \(session.title) - ID: \(session.id) - Created: \(session.createdAt)")
            }
        }
        .onChange(of: sessions.count) { oldCount, newCount in
            print("📱 Sessions count changed from \(oldCount) to \(newCount)")
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
        .fileImporter(
            isPresented: $showingImportPicker,
            allowedContentTypes: [UTType.testResults, UTType.json],
            allowsMultipleSelection: true
        ) { result in
            handleImport(result: result)
        }
        .alert("Import", isPresented: $importAlert) {
            Button("OK") { }
        } message: {
            Text(importMessage)
        }
        .task {
            // Debug: Alle Sessions in der Datenbank auflisten
            await debugPrintAllSessions()
        }
    }
    
    // MARK: - Private Functions
    
    private func refreshData() {
        // Force UI refresh
        Task {
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
    }
    
    private func exportAllSessions() {
        let allData = sessions.map { $0.toCodable() }
        
        do {
            let data = try JSONEncoder().encode(allData)
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("AllAssessments_\(Date().formatted(.iso8601.year().month().day())).json")
            
            try data.write(to: tempURL)
            
            // Share via ActivityViewController
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = rootVC.view
                rootVC.present(activityVC, animated: true)
            }
        } catch {
            importMessage = "Export fehlgeschlagen: \(error.localizedDescription)"
            importAlert = true
        }
    }
    
    private func handleImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            var importedCount = 0
            var errors: [String] = []
            
            for url in urls {
                do {
                    guard url.startAccessingSecurityScopedResource() else {
                        errors.append("Zugriff auf \(url.lastPathComponent) verweigert")
                        continue
                    }
                    defer { url.stopAccessingSecurityScopedResource() }
                    
                    let data = try Data(contentsOf: url)
                    
                    // Try single session first (.testinsight files)
                    if let session = try? JSONDecoder().decode(CodableTestSession.self, from: data) {
                        // Check if session already exists
                        let existingDescriptor = FetchDescriptor<TestSession>(
                            predicate: #Predicate { $0.id == session.id }
                        )
                        let existing = try? modelContext.fetch(existingDescriptor)
                        
                        if existing?.isEmpty ?? true {
                            let newSession = TestSession.fromCodable(session)
                            modelContext.insert(newSession)
                            importedCount += 1
                            print("📱 Imported session: \(session.title)")
                        } else {
                            print("📱 Session already exists: \(session.title)")
                        }
                    }
                    // Try multiple sessions (.json files)
                    else if let sessions = try? JSONDecoder().decode([CodableTestSession].self, from: data) {
                        for sessionData in sessions {
                            let existingDescriptor = FetchDescriptor<TestSession>(
                                predicate: #Predicate { $0.id == sessionData.id }
                            )
                            let existing = try? modelContext.fetch(existingDescriptor)
                            
                            if existing?.isEmpty ?? true {
                                let newSession = TestSession.fromCodable(sessionData)
                                modelContext.insert(newSession)
                                importedCount += 1
                                print("📱 Imported session: \(sessionData.title)")
                            }
                        }
                    }
                    else {
                        errors.append("Ungültiges Format: \(url.lastPathComponent)")
                    }
                } catch {
                    errors.append("Fehler bei \(url.lastPathComponent): \(error.localizedDescription)")
                    print("📱 Error importing from \(url): \(error)")
                }
            }
            
            // Save all imported sessions
            if importedCount > 0 {
                do {
                    try modelContext.save()
                    print("📱 Successfully saved \(importedCount) sessions")
                    
                    // Force UI refresh after import
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        refreshData()
                    }
                    
                    importMessage = "\(importedCount) Assessment(s) erfolgreich importiert!"
                } catch {
                    importMessage = "Fehler beim Speichern: \(error.localizedDescription)"
                    print("📱 Error saving imported sessions: \(error)")
                }
            } else if !errors.isEmpty {
                importMessage = "Import fehlgeschlagen:\n" + errors.joined(separator: "\n")
            } else {
                importMessage = "Keine neuen Assessments gefunden (möglicherweise bereits vorhanden)"
            }
            
            importAlert = true
            
        case .failure(let error):
            importMessage = "Import fehlgeschlagen: \(error.localizedDescription)"
            importAlert = true
        }
    }
    
    private func debugPrintAllSessions() async {
        let descriptor = FetchDescriptor<TestSession>()
        do {
            let allSessions = try modelContext.fetch(descriptor)
            print("📱 DEBUG: Total sessions in database: \(allSessions.count)")
            for session in allSessions {
                print("📱 DEBUG: Session - ID: \(session.id), Title: \(session.title), Created: \(session.createdAt)")
            }
        } catch {
            print("📱 DEBUG: Error fetching sessions: \(error)")
        }
    }
    
    private func deleteSessions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                print("📱 Deleting session: \(sessions[index].title)")
                modelContext.delete(sessions[index])
            }
            
            do {
                try modelContext.save()
                print("📱 Sessions deleted and saved successfully")
            } catch {
                print("📱 Error deleting session: \(error)")
            }
        }
    }
}
