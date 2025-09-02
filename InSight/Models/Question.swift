//
//  Question.swift
//  InSight
//
//  Created by Iosif Gogolos on 01.09.25.
//

import Foundation
import SwiftData

@Model
final class Question {
    var id: UUID
    var text: String
    var domain: String
    var answerValue: Int

    init(text: String, domain: String, answerValue: Int = 0) {
        self.id = UUID()
        self.text = text
        self.domain = domain
        self.answerValue = answerValue
    }
    
    // Convert to Codable representation for export/import
    func toCodable() -> CodableQuestion {
        return CodableQuestion(
            id: id,
            text: text,
            domain: domain,
            answerValue: answerValue
        )
    }
    
    // Create from Codable representation
    static func fromCodable(_ codable: CodableQuestion) -> Question {
        let question = Question(
            text: codable.text,
            domain: codable.domain,
            answerValue: codable.answerValue
        )
        question.id = codable.id
        return question
    }
}

// MARK: - Codable Data Transfer Object
struct CodableQuestion: Codable {
    let id: UUID
    let text: String
    let domain: String
    let answerValue: Int

    enum CodingKeys: String, CodingKey {
        case id, text, domain, answerValue
    }
}
