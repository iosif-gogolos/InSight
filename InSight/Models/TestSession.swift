//
//  TestSession.swift
//  InSight
//
//  Created by Iosif Gogolos on 01.09.25.
//

import Foundation
import SwiftData

@Model
final class TestSession: Hashable {
    var id: UUID
    var title: String
    var createdAt: Date
    
    var questions: [Question]
    var answers: [Int] = []
    var strengths: [String] = []
    var suggestions: [String] = []
    
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
        let s = strengths.isEmpty ? "—" : strengths.map { "• \($0)" }.joined(separator: "\n")
        let r = suggestions.isEmpty ? "—" : suggestions.map { "• \($0)" }.joined(separator: "\n")
        return """
        InSight – Ergebnis vom \(createdAt.formatted(date: .abbreviated, time: .omitted))
        
        Stärken:
        \(s)
        
        Empfehlungen:
        \(r)
        """
    }
    
    // Convert to Codable representation for export/import
    func toCodable() -> CodableTestSession {
        return CodableTestSession(
            id: id,
            title: title,
            createdAt: createdAt,
            questions: questions.map { $0.toCodable() },
            answers: answers,
            strengths: strengths,
            suggestions: suggestions,
            note: note
        )
    }
    
    // Create from Codable representation
    static func fromCodable(_ codable: CodableTestSession) -> TestSession {
        let session = TestSession(
            title: codable.title,
            questions: codable.questions.map { Question.fromCodable($0) },
            answers: codable.answers,
            strengths: codable.strengths,
            suggestions: codable.suggestions,
            note: codable.note
        )
        session.id = codable.id
        session.createdAt = codable.createdAt
        return session
    }
}

// MARK: - Codable Data Transfer Object
struct CodableTestSession: Codable {
    let id: UUID
    let title: String
    let createdAt: Date
    let questions: [CodableQuestion]
    let answers: [Int]
    let strengths: [String]
    let suggestions: [String]
    let note: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, createdAt, questions, answers, strengths, suggestions, note
    }
}
