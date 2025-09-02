//
//  Untitled.swift
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
    @State private var completedSession: TestSession? = nil   // statt Bool

    var body: some View {
        VStack {
            if questions.isEmpty {
                Text("Lade Fragen...")
                    .task { loadQuestions() }
            } else if index < questions.count {
                QuestionView(
                    question: $questions[index],
                    progress: Double(index+1) / Double(max(questions.count, 1))
                )

                // 👇 Hinweis unter dem Abstimmelement
                Text("Hinweis: 1 = Stimme gar nicht zu · 2 = Stimme teilweise nicht zu · 3 = Ich bin unentschlossen · 4 = Stimme teilweise zu · 5 = Stimme voll zu")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 4)

                HStack {
                    if index > 0 {
                        Button("Zurück") { index -= 1 }
                    }
                    Spacer()
                    Button(index == questions.count-1 ? "Fertig" : "Weiter") {
                        if index == questions.count-1 {
                            // Auswertung und Speichern
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

                            modelContext.insert(session)
                            try? modelContext.save()

                            completedSession = session
                        } else {
                            index += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                Text("Keine Fragen vorhanden.")
            }
        }
        .sheet(item: $completedSession) { session in
            ResultsView(session: session, onRetake: resetFlow)
        }
        .navigationTitle("Test")
    }

    private func resetFlow() {
        index = 0
        for i in questions.indices {
            questions[i].answerValue = 0
        }
        completedSession = nil
    }

    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
            print("JSON gefunden im Bundle: \(url)")
        } else {
            print("JSON nicht gefunden")
        }
        if let qs = JSONLoader.loadQuestions(from: "questions") {
            print("Fragen geladen: \(qs.count)")
            questions = qs
        } else {
            print("Fallback: Beispiel-Fragen")
            questions = [
                Question(text: "Beispiel-Frage 1", domain: "Demo"),
                Question(text: "Beispiel-Frage 2", domain: "Demo")
            ]
        }
    }
}

// Für .sheet(item:) – Identifiable konform machen (falls nicht schon woanders getan)
extension TestSession: Identifiable {}
