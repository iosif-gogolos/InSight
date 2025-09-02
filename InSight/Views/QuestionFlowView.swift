//
//  QuestionFlowView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI
import SwiftData

struct QuestionFlowView: View {
    @State private var questions: [Question] = []
    @State private var index: Int = 0
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var completedSession: TestSession? = nil
    @State private var showValidationAlert = false
    
    var onComplete: () -> Void // Callback when completely done
    
    var body: some View {
        VStack {
            if questions.isEmpty {
                Text("Lade Fragen...")
                    .task { loadQuestions() }
            } else if index < questions.count {
                VStack(spacing: 20) {
                    QuestionView(
                        question: $questions[index],
                        progress: Double(index+1) / Double(max(questions.count, 1))
                    )
                    
                    // Hinweis direkt unter den Auswahlmöglichkeiten
                    VStack(spacing: 8) {
                        Text("Bewertungsskala:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("1 = Stimme gar nicht zu")
                            Text("2 = Stimme teilweise nicht zu")
                            Text("3 = Ich bin unentschlossen")
                            Text("4 = Stimme teilweise zu")
                            Text("5 = Stimme voll zu")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Navigation buttons
                    HStack {
                        if index > 0 {
                            Button("Zurück") {
                                index -= 1
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Spacer()
                        
                        Button(index == questions.count-1 ? "Fertig" : "Weiter") {
                            // Eingabevalidierung
                            if questions[index].answerValue == 0 {
                                showValidationAlert = true
                                return
                            }
                            
                            if index == questions.count-1 {
                                finishTest()
                            } else {
                                index += 1
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(questions.isEmpty)
                    }
                    .padding()
                }
            } else {
                Text("Keine Fragen vorhanden.")
            }
        }
        .sheet(item: $completedSession) { session in
            NavigationStack {
                ResultsView(
                    session: session,
                    onRetake: resetFlow,
                    onComplete: {
                        completedSession = nil
                        dismiss()
                        onComplete()
                    }
                )
            }
        }
        .alert("Antwort erforderlich", isPresented: $showValidationAlert) {
            Button("OK") { }
        } message: {
            Text("Bitte wählen Sie eine Antwort aus, bevor Sie fortfahren.")
        }
        .navigationTitle("Test (\(index + 1)/\(questions.count))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Abbrechen") {
                    dismiss()
                    onComplete()
                }
            }
        }
    }
    
    private func finishTest() {
        let unansweredQuestions = questions.filter { $0.answerValue == 0 }
        if !unansweredQuestions.isEmpty {
            showValidationAlert = true
            return
        }
        
        let (strengths, suggestions, _) = evaluateDomains(from: questions)
        let answers = questions.map { $0.answerValue }
        let title = "Self-Assessment \(Date.now.formatted(date: .numeric, time: .omitted))"

        let session = TestSession(
            title: title,
            questions: questions,
            answers: answers,
            strengths: strengths,
            suggestions: suggestions
        )

        // Insert and save immediately when test is finished
        modelContext.insert(session)
        do {
            try modelContext.save()
            print("Session saved successfully: \(session.title)")
        } catch {
            print("Error saving session: \(error)")
        }

        completedSession = session
    }

    private func resetFlow() {
        index = 0
        for i in questions.indices {
            questions[i].answerValue = 0
        }
        completedSession = nil
    }

    private func loadQuestions() {
        if let qs = JSONLoader.loadQuestions(from: "questions") {
            questions = qs
        } else {
            questions = [
                Question(text: "Beispiel-Frage 1", domain: "Demo"),
                Question(text: "Beispiel-Frage 2", domain: "Demo")
            ]
        }
    }
}
