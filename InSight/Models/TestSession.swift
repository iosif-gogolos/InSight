//
//  TestSession.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import Foundation
import SwiftData

@Model
final class TestSession {
    var id: UUID
    var title: String
    var createdAt: Date
    var questions: [Question]        // für Nachvollziehbarkeit
    var answers: [Int]               // 1..5 je Frage
    var strengths: [String]
    var suggestions: [String]
    var note: String?

    init(title: String,
         questions: [Question] = [],
         answers: [Int] = [],
         strengths: [String] = [],
         suggestions: [String] = [],
         note: String? = nil) {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.questions = questions
        self.answers = answers
        self.strengths = strengths
        self.suggestions = suggestions
        self.note = note
    }

    // Praktische Zusammenfassung für ShareLink
    var resultsSummary: String {
        let s = strengths.isEmpty ? "–" : strengths.map { "• \($0)" }.joined(separator: "\n")
        let r = suggestions.isEmpty ? "–" : suggestions.map { "• \($0)" }.joined(separator: "\n")
        return """
        InSight – Ergebnis vom \(createdAt.formatted(date: .abbreviated, time: .omitted))

        Stärken:
        \(s)

        Empfehlungen:
        \(r)
        """
    }
}
